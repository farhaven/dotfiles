" For detecing the KOS script filename from its contents:
if did_filetype()	" filetype already set..
  finish		" ..don't do these checks
endif
if getline(1) =~ '^[ \t]*//KOS'
  setfiletype kos
endif
