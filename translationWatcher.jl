using JSON

struct ArbFile
  path::String
end
arbfile(path::String) = ArbFile(path)

function readfile(file::ArbFile)::Dict
  open(file.path) do f
    JSON.parse(read(f, String))
  end
end

function writefile(file::ArbFile, data::Dict)
  serial = JSON.json(data, 2)
  open(file.path, "w") do f
    write(f, serial)
  end
end

function hastranslation(arb::ArbFile, key::String)
  key in keys(readfile(arb))
end

function addtranslation!(arb::ArbFile, key::String, value::String)
  data = readfile(arb)
  data[key] = value
  writefile(arb, data)
end


function getarbfiles()::Channel{String}
  Channel{String}() do channel
    for file ∈ collect(walkdir("lib/l10n/"))[1][3]
      if startswith(file, "app") && endswith(file, ".arb")
        put!(channel, "./lib/l10n/" * file)
      end
    end
  end
end
function rebuildLocalizations()
  run(`flutter gen-l10n`)
end
function synchronizearbfiles()
  files = collect(getarbfiles()) .|> arbfile
  for file1 in files, file2 in files
    file1 == file2 && continue
    copymissingkeys(file1, file2)
  end
end
function copymissingkeys(from::ArbFile, to::ArbFile)
  data1 = readfile(from)
  data2 = readfile(to)
  missingkeys = setdiff(keys(data1), keys(data2))
  for key in missingkeys
    println("Adding missing $key to $(to.path)")
    addtranslation!(to, key, "#" * data1[key])
  end
end
function watchchanges()
    println("Watching for changes...")
    mtimes = Dict{String,Float64}()
    while true
      shouldRefresh = false
      for (normalized, text) in extractmarkedstrings()
        addtranslationkey(normalized, JSON.parse(text))
        shouldRefresh = true
      end
      synchronizearbfiles()
      for file ∈ getarbfiles()
        if file ∉ keys(mtimes)
          println(" - Adding file $file")
          mtimes[file] = mtime(file)
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
      sleep(5)
    end
end
function addtranslationkey(normalized::String, text::String) 
  for file in getarbfiles()
    arb = arbfile(file)
    !hastranslation(arb, normalized) && addtranslation!(arb, normalized, text)
  end
end
function extractmarkedstringsinfile(file::String)::Channel{Tuple{String, String}}
  Channel{Tuple{String, String}}() do channel
    while true
      found = false
      for (lineidx, line) in enumerate(open(readlines,file))
        m = match(r"_\"[^\"]+\"", line)
        isnothing(m) && continue
        normalized = normalizedtranslationname(m.match)
        put!(channel, (normalized, m.match[2:end]))
        println("Replacing $normalized in $file")
        replacetranslation(file, normalized, m.match)
        found = true
        break
      end
      !found && break
    end
  end
end
function replacetranslation(file::AbstractString, normal::String, text::AbstractString)
  content = open(file) do f
    read(f, String)
  end
  content = replace(content, text => gentranslationcaller(normal))
  open(file, "w") do f
    write(f, content)
  end
end
gentranslationcaller(name::String) = "AppLocalizations.of(context)!.$name"
function normalizedtranslationname(string::AbstractString)::String
  normal = ""
  upper = false
  for c in collect(string)
    if c == ' '
      upper = true
    elseif isletter(c)
      normal *= upper ? uppercase(c) : lowercase(c)
      upper = false
    elseif isdigit(c)
      normal *= c
      upper = false
    end
  end
  return normal
end
function extractmarkedstrings()::Channel{Tuple{String, String}}
  Channel{Tuple{String, String}}() do channel
    for (folder, _, files) ∈ walkdir("lib/")
      flush(Core.stdout)
      for file in files
        if endswith(file, ".dart") && !endswith(folder, "l10n")
          for tup in extractmarkedstringsinfile(joinpath(folder, file))
            put!(channel, tup)
          end
        end
      end
    end
  end
end
function @main(::Vector{String})::Cint
  try
    watchchanges()
  catch e
    flush(Core.stdout)
    showerror(Core.stdout, e)
  finally
    return 0
  end
end
