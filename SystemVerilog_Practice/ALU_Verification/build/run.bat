REM run.bat <top_name> [-uvm]


call "C:\Xilinx\2025.1\Vivado\settings64.bat"

echo ==== Compiling ====
call xvlog -sv -L uvm -f filelist.f

if errorlevel 1 (
    echo xvlog failed!
    exit /b
)


echo ==== Elaborating ====
call xelab -L uvm tbtop -s tbtop
if errorlevel 1 (
    echo xelab failed!
    exit /b
)

echo ==== Simulating ====
call xsim tbtop -runall
if errorlevel 1 (
    echo xsim failed!
    exit /b
)