Imports System.IO
Imports System.Windows.Forms

Public Class MainForm
    Inherits Form
    Private processTable As DataGridView
    Private startButton As Button
    Private processList As String() = {
        "lsproxy.exe",
        "client32.exe",
        "Client32.exe",
        "Runplugin64.exe",
        "runplugin.exe",
        "LSSASvc.exe",
        "smart-agent-js-win.exe",
        "makeca.exe"
    }

    Public Sub New()
        processTable = New DataGridView With {
            .Dock = DockStyle.Bottom,
            .Height = 220,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .RowHeadersVisible = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .ReadOnly = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }
        processTable.Columns.Add("ProcessName", "Process Name")
        Dim killCol As New DataGridViewCheckBoxColumn With {
            .Name = "KillSwitch",
            .HeaderText = "Kill?",
            .TrueValue = True,
            .FalseValue = False
        }
        processTable.Columns.Add(killCol)
        For Each proc In processList
            processTable.Rows.Add(proc, True)
        Next
        Controls.Add(processTable)
        startButton = New Button With {
            .Text = "Start",
            .Dock = DockStyle.Bottom,
            .Height = 40
        }
        AddHandler startButton.Click, AddressOf StartButton_Click
        Controls.Add(startButton)
        Me.Height = 350
        Me.Width = 460
        Me.Text = "School Anti-Block - Process Selection"
    End Sub

    Private Sub StartButton_Click(sender As Object, e As EventArgs)
        Dim enabledProcesses As New List(Of String)
        For Each row As DataGridViewRow In processTable.Rows
            Dim procName = row.Cells("ProcessName").Value.ToString()
            Dim enabled = If(row.Cells("KillSwitch").Value IsNot Nothing, CBool(row.Cells("KillSwitch").Value), False)
            If enabled Then enabledProcesses.Add(procName)
        Next
        File.WriteAllLines("processes.txt", enabledProcesses)
        Close()
    End Sub
End Class

Module Program
    Sub Main()
        Application.EnableVisualStyles()
        Application.SetCompatibleTextRenderingDefault(False)
        Application.Run(New MainForm())
    End Sub
End Module
