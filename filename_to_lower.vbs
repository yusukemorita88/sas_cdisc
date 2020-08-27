Call ToLower       'Call Sub Routine

Sub ToLower()
    Dim objFso      ' As FileSystemObject
    Dim objFolder   ' As Folder
    Dim objFile     ' As File
    Dim strName
    Dim strExtension
    Dim strNewName

    'confirm
    if MsgBox("Execute ?", vbYesNo ) = vbNo then
        Exit Sub
    end if
 
    'setup
    Set objFso = Wscript.CreateObject("Scripting.FileSystemObject")
    Set objFolder = objFso.GetFolder(".")   'Get Current Folder

    'Iteration
    For Each objFile In objFolder.Files
        If Lcase(objFso.GetExtensionName(objFile)) <> "vbs" Then 'Check Extension
            strName = LCase(objFso.GetBaseName(objFile))
            strName = Replace(strName,".","_")
            strExtension = LCase(objFso.GetExtensionName(objFile))
            strNewName = strName & "." & strExtension
            objFile.Name = "_" & strNewName
            objFile.Name = strNewName
        End If
    Next

    Wscript.Echo "Completed !"

    Set objFile   = Nothing
    Set objFolder = Nothing
    Set objFso    = Nothing
End Sub
