rem Need Python 3.4 environment with pyinstaller
call activate py34
R:
cd Public\GK_lab\Eric\FMUT_development\FMUT_functions
pyinstaller -F -n py_fmut fmut.py
call deactivate