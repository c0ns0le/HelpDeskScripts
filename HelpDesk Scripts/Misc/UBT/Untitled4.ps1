function GenerateForm {

#param (
#   [Object] $PCNames = $null   
#)

$PCNames = @("PC1","PC2","PC3")

[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

$form1 = New-Object System.Windows.Forms.Form
$button1 = New-Object System.Windows.Forms.Button
$listBox1 = New-Object System.Windows.Forms.ListBox

foreach ($checkBox in $PCNames) {
    $checkBox = New-Object System.Windows.Forms.CheckBox
}
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

$b1= $false
$b2= $false
$b3= $false

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------

$handler_button1_Click= 
{
    $listBox1.Items.Clear();

    foreach ($checkBox in $PCNames) {

    if ($checkBox.Checked)     {  $listBox1.Items.Add( "$checkBox is checked"  ) }

    if ( !$checkBox.Checked) {   $listBox1.Items.Add("No CheckBox selected....")} 

    }
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
    $form1.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$form1.Text = "Primal Form"
$form1.Name = "form1"
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 450
$System_Drawing_Size.Height = 236
$form1.ClientSize = $System_Drawing_Size

$button1.TabIndex = 4
$button1.Name = "button1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$button1.Size = $System_Drawing_Size
$button1.UseVisualStyleBackColor = $True

$button1.Text = "Run Script"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 156
$button1.Location = $System_Drawing_Point
$button1.DataBindings.DefaultDataSourceUpdateMode = 0
$button1.add_Click($handler_button1_Click)

$form1.Controls.Add($button1)

$listBox1.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 301
$System_Drawing_Size.Height = 212
$listBox1.Size = $System_Drawing_Size
$listBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$listBox1.Name = "listBox1"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 137
$System_Drawing_Point.Y = 13
$listBox1.Location = $System_Drawing_Point
$listBox1.TabIndex = 3

$form1.Controls.Add($listBox1)


#$checkBox3.UseVisualStyleBackColor = $True
#$System_Drawing_Size = New-Object System.Drawing.Size
#$System_Drawing_Size.Width = 104
#$System_Drawing_Size.Height = 24
#$checkBox3.Size = $System_Drawing_Size
#$checkBox3.TabIndex = 2
#$checkBox3.Text = "CheckBox 3"
#$System_Drawing_Point = New-Object System.Drawing.Point
#$System_Drawing_Point.X = 27
#$System_Drawing_Point.Y = 75
#$checkBox3.Location = $System_Drawing_Point
#$checkBox3.DataBindings.DefaultDataSourceUpdateMode = 0
#$checkBox3.Name = "checkBox3"
#
#$form1.Controls.Add($checkBox3)
#
#
#$checkBox2.UseVisualStyleBackColor = $True
#$System_Drawing_Size = New-Object System.Drawing.Size
#$System_Drawing_Size.Width = 104
#$System_Drawing_Size.Height = 24
#$checkBox2.Size = $System_Drawing_Size
#$checkBox2.TabIndex = 1
#$checkBox2.Text = "CheckBox 2"
#$System_Drawing_Point = New-Object System.Drawing.Point
#$System_Drawing_Point.X = 27
#$System_Drawing_Point.Y = 44
#$checkBox2.Location = $System_Drawing_Point
#$checkBox2.DataBindings.DefaultDataSourceUpdateMode = 0
#$checkBox2.Name = "checkBox2"
#
#$form1.Controls.Add($checkBox2)


foreach ($check in $PCNames) {
    $check.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 104
    $System_Drawing_Size.Height = 24
    $check.Size = $System_Drawing_Size
    $check.TabIndex = 0
    $check.Text = "$checkBox"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 27
    $System_Drawing_Point.Y = 13
    $check.Location = $System_Drawing_Point
    $check.DataBindings.DefaultDataSourceUpdateMode = 0
    $check.Name = "$check"

$form1.Controls.Add($check)
}

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

GenerateForm