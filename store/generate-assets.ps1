# Requires: Windows PowerShell with System.Drawing
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$outDir = Join-Path $PSScriptRoot "."
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

function New-BitmapRgb([int]$w, [int]$h) {
    $bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    return @{ Bitmap = $bmp; Graphics = $g }
}

function Save-BitmapRgb($ctx, [string]$path) {
    $ctx.Graphics.Dispose()
    $ctx.Bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $ctx.Bitmap.Dispose()
}

function Get-Font([string]$family, [float]$size, [int]$style = 0) {
    return New-Object System.Drawing.Font($family, $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
}

function Draw-GradientBg($g, $rect, $c1, $c2) {
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 45)
    $g.FillRectangle($brush, $rect)
    $brush.Dispose()
}

function Draw-RoundedRect($g, $brush, $x, $y, $w, $h, $r) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($x, $y, $r, $r, 180, 90)
    $path.AddArc($x + $w - $r, $y, $r, $r, 270, 90)
    $path.AddArc($x + $w - $r, $y + $h - $r, $r, $r, 0, 90)
    $path.AddArc($x, $y + $h - $r, $r, $r, 90, 90)
    $path.CloseFigure()
    $g.FillPath($brush, $path)
    $path.Dispose()
}

function Draw-CenteredText($g, [string]$text, $font, $brush, $rect) {
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rectF = New-Object System.Drawing.RectangleF([float]$rect.X, [float]$rect.Y, [float]$rect.Width, [float]$rect.Height)
    $g.DrawString($text, $font, $brush, $rectF, $sf)
    $sf.Dispose()
}

function Draw-LeftText($g, [string]$text, $font, $brush, $x, $y, $maxWidth) {
    $rect = New-Object System.Drawing.RectangleF $x, $y, $maxWidth, 800
    $g.DrawString($text, $font, $brush, $rect)
}

function Draw-Shield($g, $x, $y, $size, $fill, $stroke) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddLine($x + $size * 0.5, $y, $x + $size * 0.95, $y + $size * 0.22)
    $path.AddLine($x + $size * 0.95, $y + $size * 0.55, $x + $size * 0.5, $y + $size)
    $path.AddLine($x + $size * 0.5, $y + $size, $x + $size * 0.05, $y + $size * 0.55)
    $path.AddLine($x + $size * 0.05, $y + $size * 0.22, $x + $size * 0.5, $y)
    $path.CloseFigure()
    $g.FillPath($fill, $path)
    $g.DrawPath($stroke, $path)
    $path.Dispose()
}

function Draw-Icon($g, $x, $y, $size) {
    $bg = [System.Drawing.Color]::FromArgb(255, 145, 70, 255)
    $brush = New-Object System.Drawing.SolidBrush $bg
    Draw-RoundedRect $g $brush $x $y $size $size ($size * 0.22)
    $brush.Dispose()
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::White), ([Math]::Max(3, $size / 18))
    $m = $size * 0.28
    $g.DrawLine($pen, $x + $m, $y + $m, $x + $size - $m, $y + $size - $m)
    $g.DrawLine($pen, $x + $size - $m, $y + $m, $x + $m, $y + $size - $m)
    $pen.Dispose()
}

$purple = [System.Drawing.Color]::FromArgb(255, 145, 70, 255)
$purpleDark = [System.Drawing.Color]::FromArgb(255, 70, 35, 130)
$bgDark = [System.Drawing.Color]::FromArgb(255, 14, 14, 16)
$panel = [System.Drawing.Color]::FromArgb(255, 24, 24, 27)
$border = [System.Drawing.Color]::FromArgb(255, 47, 47, 53)
$text = [System.Drawing.Color]::FromArgb(255, 239, 239, 241)
$muted = [System.Drawing.Color]::FromArgb(255, 173, 173, 184)
$green = [System.Drawing.Color]::FromArgb(255, 0, 245, 147)

# --- Store icon 128x128 ---
$icon = New-BitmapRgb 128 128
Draw-Icon $icon.Graphics 0 0 128
Save-BitmapRgb $icon (Join-Path $outDir "icon-128.png")

# --- Screenshot helper ---
function New-Screenshot([string]$name, [scriptblock]$draw) {
    $ctx = New-BitmapRgb 1280 800
    $rect = New-Object System.Drawing.Rectangle 0, 0, 1280, 800
    Draw-GradientBg $ctx.Graphics $rect $bgDark $purpleDark
    & $draw $ctx.Graphics
    Save-BitmapRgb $ctx (Join-Path $outDir $name)
}

# Screenshot 1: Hero
New-Screenshot "screenshot-01-hero.png" {
    param($g)
    Draw-Icon $g 120 280 96
    $titleFont = Get-Font "Segoe UI" 64 1
    $subFont = Get-Font "Segoe UI" 28 0
    $g.DrawString("Twitch AdBlock", $titleFont, (New-Object System.Drawing.SolidBrush $text), 250, 285)
    $g.DrawString("Block video ads. Protect your viewing experience.", $subFont, (New-Object System.Drawing.SolidBrush $muted), 250, 365)
    $pillBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 35, 35, 42))
    Draw-RoundedRect $g $pillBrush 250 430 520 52 26
    $pillBrush.Dispose()
    $tagFont = Get-Font "Segoe UI" 20 0
    $g.DrawString("Privacy-focused  |  No data collection  |  Open source", $tagFont, (New-Object System.Drawing.SolidBrush $green), 270, 443)
    $titleFont.Dispose(); $subFont.Dispose(); $tagFont.Dispose()
}

# Screenshot 2: Popup mockup
New-Screenshot "screenshot-02-popup.png" {
    param($g)
    $titleFont = Get-Font "Segoe UI" 42 1
    $g.DrawString("Simple toolbar control", $titleFont, (New-Object System.Drawing.SolidBrush $text), 90, 90)
    $titleFont.Dispose()
    $subFont = Get-Font "Segoe UI" 22 0
    $g.DrawString("Turn ad blocking on or off from the extension popup.", $subFont, (New-Object System.Drawing.SolidBrush $muted), 90, 150)
    $subFont.Dispose()
    $panelBrush = New-Object System.Drawing.SolidBrush $panel
    Draw-RoundedRect $g $panelBrush 760 180 380 280 16
    $panelBrush.Dispose()
    $borderPen = New-Object System.Drawing.Pen $border, 2
    $g.DrawRectangle($borderPen, 760, 180, 380, 280)
    $borderPen.Dispose()
    Draw-Icon $g 780 200 40
    $hFont = Get-Font "Segoe UI" 20 1
    $g.DrawString("Twitch AdBlock", $hFont, (New-Object System.Drawing.SolidBrush $text), 830, 205)
    $sFont = Get-Font "Segoe UI" 13 0
    $g.DrawString("Stream-level ad blocking", $sFont, (New-Object System.Drawing.SolidBrush $muted), 830, 232)
    $rowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 35, 35, 42))
    Draw-RoundedRect $g $rowBrush 780 270 340 56 10
    $rowBrush.Dispose()
    $g.DrawString("Block video ads", (Get-Font "Segoe UI" 16 0), (New-Object System.Drawing.SolidBrush $text), 795, 288)
    $toggleBrush = New-Object System.Drawing.SolidBrush $purple
    Draw-RoundedRect $g $toggleBrush 1060 286 44 24 12
    $toggleBrush.Dispose()
    $dotBrush = New-Object System.Drawing.SolidBrush $text
    $g.FillEllipse($dotBrush, 1080, 290, 16, 16)
    $dotBrush.Dispose()
    $g.DrawString("Enabled. Open Twitch tabs reload automatically.", (Get-Font "Segoe UI" 12 0), (New-Object System.Drawing.SolidBrush $green), 780, 345)
    $hFont.Dispose(); $sFont.Dispose()
}

# Screenshot 3: Privacy
New-Screenshot "screenshot-03-privacy.png" {
    param($g)
    $fill = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(80, 145, 70, 255))
    $stroke = New-Object System.Drawing.Pen $purple, 4
    Draw-Shield $g 140 250 180 $fill $stroke
    $fill.Dispose(); $stroke.Dispose()
    $titleFont = Get-Font "Segoe UI" 48 1
    $g.DrawString("Privacy by design", $titleFont, (New-Object System.Drawing.SolidBrush $text), 360, 270)
    $titleFont.Dispose()
    $bodyFont = Get-Font "Segoe UI" 24 0
    $lines = @(
        "No personal data collected",
        "No analytics or tracking",
        "One local on/off preference only",
        "No remote code execution",
        "Open source and auditable"
    )
    $y = 350
    foreach ($line in $lines) {
        $checkBrush = New-Object System.Drawing.SolidBrush $green
        $g.FillEllipse($checkBrush, 370, $y + 8, 12, 12)
        $checkBrush.Dispose()
        $g.DrawString($line, $bodyFont, (New-Object System.Drawing.SolidBrush $muted), 395, $y)
        $y += 48
    }
    $bodyFont.Dispose()
}

# Screenshot 4: How it works
New-Screenshot "screenshot-04-how-it-works.png" {
    param($g)
    $titleFont = Get-Font "Segoe UI" 42 1
    $g.DrawString("Stream-level protection", $titleFont, (New-Object System.Drawing.SolidBrush $text), 90, 80)
    $titleFont.Dispose()
    $subFont = Get-Font "Segoe UI" 22 0
    $g.DrawString("Intercepts Twitch video workers before ads reach the player.", $subFont, (New-Object System.Drawing.SolidBrush $muted), 90, 140)
    $subFont.Dispose()
    $steps = @(
        @{ N = "1"; T = "Inject at page load"; D = "Runs at document_start on twitch.tv" },
        @{ N = "2"; T = "Hook video workers"; D = "Intercepts HLS stream processing" },
        @{ N = "3"; T = "Detect ad segments"; D = "Identifies ads in .m3u8 playlists" },
        @{ N = "4"; T = "Deliver clean stream"; D = "Requests ad-free variants when needed" }
    )
    $x = 90; $y = 220
    foreach ($step in $steps) {
        $card = New-Object System.Drawing.SolidBrush $panel
        Draw-RoundedRect $g $card $x $y 260 200 14
        $card.Dispose()
        $numBrush = New-Object System.Drawing.SolidBrush $purple
        $g.FillEllipse($numBrush, $x + 20, $y + 20, 40, 40)
        $numBrush.Dispose()
        Draw-CenteredText $g $step.N (Get-Font "Segoe UI" 20 1) (New-Object System.Drawing.SolidBrush $text) (New-Object System.Drawing.Rectangle ($x+20), ($y+20), 40, 40)
        $g.DrawString($step.T, (Get-Font "Segoe UI" 18 1), (New-Object System.Drawing.SolidBrush $text), ($x + 20), ($y + 75))
        $g.DrawString($step.D, (Get-Font "Segoe UI" 14 0), (New-Object System.Drawing.SolidBrush $muted), ($x + 20), ($y + 110))
        $x += 290
    }
}

# Screenshot 5: Control
New-Screenshot "screenshot-05-control.png" {
    param($g)
    $titleFont = Get-Font "Segoe UI" 48 1
    Draw-CenteredText $g "You're in control" $titleFont (New-Object System.Drawing.SolidBrush $text) (New-Object System.Drawing.Rectangle 0, 120, 1280, 70)
    $titleFont.Dispose()
    $subFont = Get-Font "Segoe UI" 24 0
    Draw-CenteredText $g "Enable or disable ad blocking anytime from the toolbar." $subFont (New-Object System.Drawing.SolidBrush $muted) (New-Object System.Drawing.Rectangle 0, 200, 1280, 40)
    $subFont.Dispose()
    $onBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 30, 55, 45))
    $offBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 45, 30, 30))
    Draw-RoundedRect $g $onBrush 220 320 380 200 16
    Draw-RoundedRect $g $offBrush 680 320 380 200 16
    $onBrush.Dispose(); $offBrush.Dispose()
    $g.DrawString("Blocking ON", (Get-Font "Segoe UI" 28 1), (New-Object System.Drawing.SolidBrush $green), 300, 360)
    $g.DrawString("Ads blocked on Twitch streams", (Get-Font "Segoe UI" 18 0), (New-Object System.Drawing.SolidBrush $muted), 255, 410)
    $g.DrawString("Blocking OFF", (Get-Font "Segoe UI" 28 1), (New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 235, 64, 64))), 755, 360)
    $g.DrawString("Standard Twitch playback", (Get-Font "Segoe UI" 18 0), (New-Object System.Drawing.SolidBrush $muted), 730, 410)
}

# --- Small promo 440x280 ---
$small = New-BitmapRgb 440 280
$sr = New-Object System.Drawing.Rectangle 0, 0, 440, 280
Draw-GradientBg $small.Graphics $sr $purpleDark $bgDark
Draw-Icon $small.Graphics 24 24 56
$small.Graphics.DrawString("Twitch AdBlock", (Get-Font "Segoe UI" 28 1), (New-Object System.Drawing.SolidBrush $text), 95, 30)
$small.Graphics.DrawString("Block ads. Protect privacy.", (Get-Font "Segoe UI" 16 0), (New-Object System.Drawing.SolidBrush $muted), 95, 68)
Save-BitmapRgb $small (Join-Path $outDir "promo-small-440x280.png")

# --- Marquee promo 1400x560 ---
$marquee = New-BitmapRgb 1400 560
$mr = New-Object System.Drawing.Rectangle 0, 0, 1400, 560
Draw-GradientBg $marquee.Graphics $mr $bgDark $purpleDark
Draw-Icon $marquee.Graphics 80 180 120
$marquee.Graphics.DrawString("Twitch AdBlock", (Get-Font "Segoe UI" 72 1), (New-Object System.Drawing.SolidBrush $text), 240, 185)
$marquee.Graphics.DrawString("Privacy-focused ad blocking for Twitch live streams", (Get-Font "Segoe UI" 30 0), (New-Object System.Drawing.SolidBrush $muted), 240, 280)
$pill = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 35, 35, 42))
Draw-RoundedRect $marquee.Graphics $pill 240 360 700 56 28
$pill.Dispose()
$marquee.Graphics.DrawString("No data collection  |  Open source  |  Simple on/off control", (Get-Font "Segoe UI" 22 0), (New-Object System.Drawing.SolidBrush $green), 265, 375)
Save-BitmapRgb $marquee (Join-Path $outDir "promo-marquee-1400x560.png")

Write-Host "Store assets generated in $outDir"
