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
Call checkForbiddenChar(objFolder, numDepth, "")


'オブジェクトを解放
Set objFolderItems = Nothing
Set objFolder = Nothing
Set objFSO = Nothing

WScript.Echo "Completed !"

'Subroutine
Sub checkForbiddenChar(tmpFolderItems, depth, parentName)

    Dim objItem
    Dim curDepth
    
    curDepth = depth + 1

    If curDepth > SEARCH_DEPTH then Exit Sub

    'Iteration
    For Each objItem in tmpFolderItems.Files
        If charCheck(objFso.GetBaseName(objItem)) or charCheckExtensition(objFso.GetExtensionName(objItem)) then
             MsgBox parentName & objItem.Name
        End If
    Next

    'Recursive processing if there are sub-folders
    If tmpFolderItems.SubFolders.Count > 0 Then
        For Each objItem in tmpFolderItems.SubFolders
            Call checkForbiddenChar(objItem, curDepth, parentName & objItem.Name & FOLDER_SEPARATOR)
        Next
    End If

    Set objItem = Nothing

End Sub

Function charCheck(strLen)
    Dim objRE
    Set objRE = new RegExp
    objRE.IgnoreCase = True
    objRE.pattern = "[^a-z0-9\-_]"
    charCheck = objRE.Test(strLen)
    Set objRE = Nothing
End Function

Function charCheckExtensition(strLen)
    Dim objRE
    Set objRE = new RegExp
    objRE.IgnoreCase = True
    objRE.pattern = "[^a-z0-9]"
    charCheckExtensition = objRE.Test(strLen)
    Set objRE = Nothing
End Function        
