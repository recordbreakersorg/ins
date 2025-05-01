const gtag = """<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-B1F8Y6G9JP"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-B1F8Y6G9JP');
</script>"""

function addgtag(html::String)::String
  location = findfirst("<head>", html)
  if location === nothing
    error("simple head tag not found, could not add google tag")
  end
  pos = location[end]
  html[1:pos] * "\n$gtag\n" * html[pos+1:end]
end

function copylogo()
  println("- Copying logo")
  open("./build/web/favicon.png", "w") do output
    write(output, open("./logo.png") do input
      read(input, String)
    end)
  end
end

function main()
  println("- Building for web")
  run(`flutter build web`)
  println("- Adding google tag")
  tag_added = open("./build/web/index.html") do input
      addgtag(read(input, String))
    end
  open("./build/web/index.html", "w") do output
    write(output, tag_added)
  end
  copylogo()
  println("Deploying")
  try
    run(`firebase deploy --non-interactive`)
  catch
    print("faild")
  end
end

if (@__MODULE__) == Main
  main()
end
