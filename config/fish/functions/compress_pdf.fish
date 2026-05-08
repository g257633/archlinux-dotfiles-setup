function compress_pdf --description 'PDF file compressor using Ghostscript'
    if test (count $argv) -lt 1
        echo "Use: compress_pdf arquivo.pdf [quality]"
        echo "Quality: screen (low), ebook (mid), printer (high)"
        return 1
    end

    set -l input $argv[1]
    set -l output (string replace -r '\.pdf$' '_compacto.pdf' $input)
    set -l quality /ebook # Padrão: médio

    if test (count $argv) -ge 2
        switch $argv[2]
            case screen
                set quality /screen
            case ebook
                set quality /ebook
            case printer
                set quality /printer
            case prepress
                set quality /prepress
        end
    end

    echo "Compressing '$input' with quality '$quality'..."

    gs -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=$quality \
        -dNOPAUSE \
        -dQUIET \
        -dBATCH \
        -sOutputFile=$output $input

    if test $status -eq 0
        set -l old_size (du -h $input | cut -f1)
        set -l new_size (du -h $output | cut -f1)
        echo "Done! $old_size -> $new_size"
        echo "New file: $output"
    else
        echo "Error."
    end
end
