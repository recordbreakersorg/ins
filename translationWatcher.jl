function getwatcheablefile()::Channel{String}
  Channel{String}() do channel
    for file ∈ collect(walkdir("lib/l10n/"))[1][3]
      if startswith(file, "app") && endswith(file, ".arb")
        put!(channel, "./lib/l10n/" * file)
      end
    end
  end
end
function checktimer()::Channel{Nothing}
  Channel{Nothing}() do channel
    while true
      sleep(10)
      put!(channel, nothing)
    end
  end
end
function rebuildLocalizations()
  run(`flutter gen-l10n`)
end
function watchchanges()::Channel{String}
  println("Watching for changes...")
  mtimes = Dict{String,Float64}()

  for _ ∈ checktimer() # controlled checks seperation
    shouldRefresh = false
    for file ∈ getwatcheablefile()
      if file ∉ keys(mtimes)
        println(" - Adding file $file")
        mtimes[file] = mtime(file)
        shouldRefresh = true
      else
        modified = mtime(file)
        if modified > mtimes[file]
          println("File modified", last(splitdir(file)))
          mtimes[file] = modified
          shouldRefresh = true
        end
      end
    end
    shouldRefresh && rebuildLocalizations()
  end
end
function (@main)(::Vector{String})::Cint
  try
    watchchanges()
  catch e
    showerror(Core.stdout, e)
  finally
    return 0
  end
end
