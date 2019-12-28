$output_dir = 'some_dir'
$7z_exe  = 'C:\Program Files\7-Zip\7z.exe'

Get-ChildItem (Get-Location) | ForEach-Object {
	$7z_arch = $_.BaseName + ".7z"
	& $7z_exe @('x', $_.Name)
	$7z_args = @('a', '-m0=lzma', '-mx9', '-mmt2', '-md64m', $7z_arch)
	Get-ChildItem (Get-Location) -exclude *.zip, *.7z | ForEach-Object {
		$7z_args += $_
	}
	& $7z_exe $7z_args

	If ($_.Length -gt (Get-Item $7z_arch).Length) {
		Remove-Item -LiteralPath $_
		Move-Item -LiteralPath $7z_arch $output_dir
	} else {
		Remove-Item -LiteralPath $7z_arch
		Move-Item -LiteralPath $_ $output_dir
	}

	Get-ChildItem (Get-Location) -exclude *.zip, *.7z | ForEach-Object {
		Remove-Item -Recurse -LiteralPath $_
	}
}
