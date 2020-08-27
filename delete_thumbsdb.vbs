Option Explicit

'Config
Const FOLDER_SEPARATOR = "\" 
Const SEARCH_DEPTH = 99999			'Depth for Subfolder

'Variables
Dim objFSO
Dim objFolder
Dim objFolderItems
Dim objFout
Dim numDepth

'Entry Point
numDepth = 0

Set objFSO = Wscript.CreateObject("Scripting.FileSystemObject")
Set objFolder = objFso.GetFolder(".")
Call deleteThumbsDb(objFolder, numDepth, "")

Set objFolderItems = Nothing
Set objFolder = Nothing
Set objFSO = Nothing

WScript.Echo "Completed !"

'Subroutine
Sub deleteThumbsDb(tmpFolderItems, depth, parentName)

    Dim objItem
    Dim curDepth
    
    curDepth = depth + 1

    If curDepth > SEARCH_DEPTH then Exit Sub

    'Iteration
    For Each objItem in tmpFolderItems.Files
        If Lcase(objItem.Name) = "thumbs.db" then
             If MsgBox("Delete ?" & vbCrLf & objItem.Path, vbYesNo) = vbYes then
                 objFSO.DeleteFile objItem
             End If
        End If
    Next

    'Recursive processing if there are subfolders
    If tmpFolderItems.SubFolders.Count > 0 Then
        For Each objItem in tmpFolderItems.SubFolders
            Call deleteThumbsDb(objItem, curDepth, parentName & objItem.Name & FOLDER_SEPARATOR)
        Next
    End If

    Set objItem = Nothing

End Sub
