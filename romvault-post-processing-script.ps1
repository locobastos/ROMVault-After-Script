$source_dir = 'D:\ROMVault\RomRoot'
$dest_dir = 'D:\ROMVault\RomRootCompressed'
$7z_exe  = 'C:\Program Files\7-Zip\7z.exe'

# Create the destination directory if it does not exist
if (-not (Test-Path $dest_dir)) { mkdir $dest_dir }

cd $source_dir
# For each folder
Get-ChildItem (Get-Location) | ForEach-Object {
    # Create the destination folder if it does not exist
    $romset_dir = "$dest_dir\$_"
    if (-not (Test-Path $romset_dir)) { mkdir $romset_dir }

    cd $_
    # For each .zip files
    Get-ChildItem (Get-Location) | ForEach-Object {
        $zip_arch = $_.BaseName + ".zip"
        $7z_arch = $_.BaseName + ".7z"
        # Extract the original zip file
        & $7z_exe @('x', $_.Name)
        # -m0    = compression method, here LZMA
        # -mx9   = compression level, here 9
        # -mmt2  = sets multithreading mode, here uses 2 cores (LZMA uses 2 cores maximum)
        $7z_args = @('a', '-m0=lzma', '-mx9', '-mmt2', $7z_arch)

        # For each filevgs contained in the original zip file
        Get-ChildItem (Get-Location) -exclude *.zip, *.7z | ForEach-Object {
            # Adding the files in the arguments's list
            $7z_args += $_
        }
        # Create the 7z archive
        & $7z_exe $7z_args

        # Compare the size of the original and the new archive, then keep the smallest
        If ((Get-Item -LiteralPath $zip_arch).Length -gt (Get-Item -LiteralPath $7z_arch).Length) {
            Remove-Item -LiteralPath $_
            Move-Item -LiteralPath (Get-Item -LiteralPath $7z_arch) $romset_dir
        } else {
            Remove-Item -LiteralPath $7z_arch
            Move-Item -LiteralPath (Get-Item -LiteralPath $zip_arch) $romset_dir
        }

        # Remove extracted files
        Get-ChildItem (Get-Location) -exclude *.zip, *.7z | ForEach-Object {
            Remove-Item -LiteralPath $_
        }
    }

    cd ..
    # Remove the folder we have just done
    Remove-Item -Recurse -LiteralPath $_
}
