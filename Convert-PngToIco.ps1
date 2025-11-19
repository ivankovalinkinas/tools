<#
.SYNOPSIS
    Converte uma imagem PNG em múltiplos arquivos ICO com tamanhos específicos.

.DESCRIPTION
    Este script utiliza recursos nativos do Windows (.NET Framework) para 
    redimensionar e converter uma imagem PNG em 4 arquivos ICO com dimensões
    de 16x16, 24x24, 32x32 e 128x128 pixels.

.PARAMETER SourcePng
    Caminho completo para o arquivo PNG de origem.

.EXAMPLE
    .\Convert-PngToIco.ps1 -SourcePng "C:\imagens\logo.png"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePng
)

# Carrega os assemblies necessários do .NET Framework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# Função para redimensionar imagem mantendo a qualidade
function Resize-Image {
    param(
        [System.Drawing.Image]$Image,
        [int]$Width,
        [int]$Height
    )
    
    # Cria um novo bitmap com as dimensões especificadas
    $resizedBitmap = New-Object System.Drawing.Bitmap($Width, $Height)
    
    # Configura o objeto Graphics para alta qualidade de redimensionamento
    $graphics = [System.Drawing.Graphics]::FromImage($resizedBitmap)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    
    # Desenha a imagem redimensionada
    $graphics.DrawImage($Image, 0, 0, $Width, $Height)
    $graphics.Dispose()
    
    return $resizedBitmap
}

# Função para converter Bitmap em formato ICO
function Save-AsIco {
    param(
        [System.Drawing.Bitmap]$Bitmap,
        [string]$OutputPath
    )
    
    try {
        # Cria um stream de arquivo
        $fileStream = [System.IO.File]::Create($OutputPath)
        
        # Cria um BinaryWriter para escrever o formato ICO manualmente
        $writer = New-Object System.IO.BinaryWriter($fileStream)
        
        # Salva o bitmap em um MemoryStream como PNG
        $pngStream = New-Object System.IO.MemoryStream
        $Bitmap.Save($pngStream, [System.Drawing.Imaging.ImageFormat]::Png)
        $pngBytes = $pngStream.ToArray()
        
        # https://learn.microsoft.com/en-us/previous-versions/ms997538(v=msdn.10)
        # Escreve o cabeçalho ICO (6 bytes)
        $writer.Write([UInt16]0)           # Reserved (sempre 0)
        $writer.Write([UInt16]1)           # Type (1 = ICO)
        $writer.Write([UInt16]1)           # Número de imagens
        
        # Escreve o diretório de entrada ICO (16 bytes)
        $writer.Write([byte]$Bitmap.Width)       # Largura (0 = 256)
        $writer.Write([byte]$Bitmap.Height)      # Altura (0 = 256)
        $writer.Write([byte]0)                   # Paleta de cores (0 = não usa paleta)
        $writer.Write([byte]0)                   # Reserved
        $writer.Write([UInt16]1)                 # Color planes
        $writer.Write([UInt16]32)                # Bits por pixel
        $writer.Write([UInt32]$pngBytes.Length)  # Tamanho dos dados da imagem
        $writer.Write([UInt32]22)                # Offset dos dados (6 + 16 = 22)
        
        # Escreve os dados PNG
        $writer.Write($pngBytes)
        
        # Fecha os streams
        $writer.Close()
        $fileStream.Close()
        $pngStream.Dispose()
        
        Write-Host "✓ Arquivo criado: $OutputPath" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Erro ao salvar $OutputPath : $_" -ForegroundColor Red
        
        # Garante o fechamento dos streams em caso de erro
        if ($writer) { $writer.Dispose() }
        if ($fileStream) { $fileStream.Dispose() }
        if ($pngStream) { $pngStream.Dispose() }
    }
}

# ====================
# INÍCIO DO SCRIPT
# ====================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Conversor PNG → ICO (Multi-tamanhos)" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Valida se o arquivo PNG existe
if (-not (Test-Path $SourcePng)) {
    Write-Host "✗ ERRO: Arquivo não encontrado: $SourcePng" -ForegroundColor Red
    exit 1
}

# Valida se é realmente um arquivo PNG
if ([System.IO.Path]::GetExtension($SourcePng).ToLower() -ne ".png") {
    Write-Host "✗ ERRO: O arquivo deve ter extensão .png" -ForegroundColor Yellow
    exit 1
}

Write-Host "Arquivo de origem: $SourcePng`n" -ForegroundColor White

# Define os tamanhos para conversão
$sizes = @(16, 24, 32, 128)

# Obtém informações do arquivo de origem
$sourceDirectory = Split-Path $SourcePng -Parent
$sourceFileName = [System.IO.Path]::GetFileNameWithoutExtension($SourcePng)

try {
    # Carrega a imagem PNG original
    Write-Host "Carregando imagem PNG..." -ForegroundColor Yellow
    $originalImage = [System.Drawing.Image]::FromFile($SourcePng)
    Write-Host "✓ Imagem carregada com sucesso! ($($originalImage.Width)x$($originalImage.Height))`n" -ForegroundColor Green
    
    # Processa cada tamanho
    foreach ($size in $sizes) {
        Write-Host "Processando tamanho ${size}x${size}..." -ForegroundColor Yellow
        
        # Define o caminho de saída
        $outputPath = Join-Path $sourceDirectory "${sourceFileName}_${size}x${size}.ico"
        
        # Redimensiona a imagem
        $resizedImage = Resize-Image -Image $originalImage -Width $size -Height $size
        
        # Salva como ICO
        Save-AsIco -Bitmap $resizedImage -OutputPath $outputPath
        
        # Libera o bitmap redimensionado
        $resizedImage.Dispose()
    }
    
    # Libera a imagem original
    $originalImage.Dispose()
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  Conversão concluída com sucesso!" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "Arquivos gerados no diretório:" -ForegroundColor White
    Write-Host "  $sourceDirectory`n" -ForegroundColor Gray
}
catch {
    Write-Host "`n✗ ERRO durante a conversão: $_" -ForegroundColor Red
    exit 1
}