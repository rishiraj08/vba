Sub MergeFormatCell()
'Updateby Extendoffice
    Dim xSRg As Range
    Dim xDRg As Range
    Dim xRgEachRow As Range
    Dim xRgEach As Range
    Dim xRgVal As String
    Dim I As Integer
    Dim xRgLen As Integer
    Dim xSRgRows As Integer
    Dim xAddress As String
    On Error Resume Next
    xAddress = ActiveWindow.RangeSelection.Address
    Set xSRg = Application.InputBox("Please select cell columns to concatenate:", "KuTools For Excel", xAddress, , , , , 8)
    If xSRg Is Nothing Then Exit Sub
    xSRgRows = xSRg.Rows.Count
    Set xDRg = Application.InputBox("Please select cells to output the result:", "KuTools For Excel", , , , , , 8)
    If xDRg Is Nothing Then Exit Sub
    Set xDRg = xDRg(1)
    For I = 1 To xSRgRows
        xRgLen = 1
        With xDRg.Offset(I - 1)
            .Value = vbNullString
            .ClearFormats
            Set xRgEachRow = xSRg(1).Offset(I - 1).Resize(1, xSRg.Columns.Count)
            For Each xRgEach In xRgEachRow
                .Value = .Value & Trim(xRgEach.Value) & " "
            Next
            For Each xRgEach In xRgEachRow
                xRgVal = xRgEach.Value
                With .Characters(xRgLen, Len(Trim(xRgVal))).Font
                .Name = xRgEach.Font.Name
                .FontStyle = xRgEach.Font.FontStyle
                .Size = xRgEach.Font.Size
                .Strikethrough = xRgEach.Font.Strikethrough
                .Superscript = xRgEach.Font.Superscript
                .Subscript = xRgEach.Font.Subscript
                .OutlineFont = xRgEach.Font.OutlineFont
                .Shadow = xRgEach.Font.Shadow
                .Underline = xRgEach.Font.Underline
                .ColorIndex = xRgEach.Font.ColorIndex
                End With
                xRgLen = xRgLen + Len(Trim(xRgVal)) + 1
            Next
        End With
    Next I
End Sub
