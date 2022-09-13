require'format'.setup{
  ["*"] = {
    { cmd = { "sed -i 's/[ \t]*$//'" } } -- remove trailing whitespace
  },
  rust = {
    { cmd = {
      function(file)
        return string.format("rustfmt %s", file)
      end
    } }
  }
}
