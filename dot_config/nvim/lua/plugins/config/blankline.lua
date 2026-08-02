local ok, blankline = pcall(require, 'ibl')

if not ok then
  return
end

blankline.setup()
