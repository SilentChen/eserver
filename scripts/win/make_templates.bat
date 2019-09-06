set ERL=G:\erlang\bin\erl.exe
set ADMIN_PATH=./templates/blog/admin
cd ../
%ERL% 	-pa ebin_erlydtl ^
		-noshell ^
		-eval " {ok,Files}=file:list_dir('%ADMIN_PATH%'),Fun=fun(F)-> N=filename:basename(F,'.html'), erlydtl:compile(filename:join('%ADMIN_PATH%',F),N,[{out_dir,'ebin_templates'},{debug_compiler, false}]) end, [Fun(F) || F<-Files]" ^
		-eval "init:stop()"
		
pause