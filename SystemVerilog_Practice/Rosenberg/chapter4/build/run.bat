call "C:\Xilinx\2025.1\Vivado\settings64.bat"

echo ==== Compiling ====
call xvlog -sv -L uvm -f filelist.f

if errorlevel 1 (
    echo xvlog failed!
    exit /b
)

echo YORUOIUEOIRUOIWUROIEWUIOE

echo ==== Elaborating ====
call xelab -L uvm test1 -s test1
if errorlevel 1 (
    echo xelab failed!
    exit /b
)

echo ==== Simulating ====
call xsim test1 -runall
if errorlevel 1 (
    echo xsim failed!
    exit /b
)