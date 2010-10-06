if did_filetype()	" filetype already set..
    finish		" ..don't do these checks
endif
if ( getline(1) . getline(2) . getline(3) =~ '\[%' )
    setf tt2
endif
