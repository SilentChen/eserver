set ERL=G:/erlang/bin/erl.exe

cd ..\ebin

del *.beam

cd ..\ebin_mochi

del *.beam

cd ..\ebin_erlydtl

del *.beam

cd ..\ebin_mysql

del *.beam

cd ..\ebin_protobuf

del *.beam

cd ..\ebin_server

del *.beam

cd ..

%ERL% -make

pause