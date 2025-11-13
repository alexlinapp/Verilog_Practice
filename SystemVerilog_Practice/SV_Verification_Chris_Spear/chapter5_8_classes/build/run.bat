REM REM is used to specify comments. Below shows how to run.
REM run.bat <top_name> [-uvm]


set FILE_TO_COMPILE=%1
if "%1"=="" (
    echo No file specified to compile!
    exit /b
)
set TOP_MODULE=%2
if "%2"=="" (
    set TOP_MODULE=top
)

call "C:\Xilinx\2025.1\Vivado\settings64.bat"

echo ==== Compiling ====
call xvlog -sv %FILE_TO_COMPILE%

if errorlevel 1 (
    echo %FILE_TO_COMPILE% compilation failed!
    echo xvlog failed!
    exit /b
)


echo ==== Elaborating ====
call xelab %TOP_MODULE% -s topsim
if errorlevel 1 (
    echo xelab failed!
    exit /b
)

echo ==== Simulating ====
call xsim topsim -runall
if errorlevel 1 (
    echo xsim failed!
    exit /b
)