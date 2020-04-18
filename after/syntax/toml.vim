" Add folding support to table arrays
syn region tomlFoldingTableArray start="^\[\[\w\+\]\]" end="^\%(\[\[\w\+\]\]\)\@=" contains=ALLBUT,tomlArray fold
