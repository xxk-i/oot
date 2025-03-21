(use-modules (guix packages)
             (guix download)
             (guix build-system gnu)
             (guix licenses))

(define mips-linux-gnu
    (package
        (name "mips-linux-gnu")
        (version "2.39")
        (source (origin
                (method url-fetch)
                (uri (string-append "https://ftp.gnu.org/gnu/binutils/binutils-" version ".tar.bz2"))
                (sha256
                (base32
                    "0j31n6vk73x2zxpghxsk99hw4ld8vrpz0b844kfh4092xx7sh96s"))))
        (build-system gnu-build-system)
        (arguments
            (list
                #:configure-flags #~'(
                    "--target=mips-linux-gnu"
                    "--disable-multilib"
                    "--with-gnu-as"
                    "--with-gnu-ld"
                    "--disable-nls"
                    "--enable-plugins"
                    "--enable-deterministic-archives")
                #:make-flags #~'("MAKEINFO=true")))
        (synopsis "mips-binutils")
        (description
    "GNU Binutils is a collection of tools for working with binary files.
Perhaps the most notable are \"ld\", a linker, and \"as\", an assembler.
Other tools include programs to display binary profiling information, list
the strings in a binary file, and utilities for working with archives.  The
\"bfd\" library for working with executable and object formats is also
included.")
        (home-page "https://www.gnu.org/software/binutils/")
        (license gpl3+)))

; (use-modules (guix packages)
;              (gnu packages gdb)               ;for 'gdb'
;              (gnu packages version-control))  ;for 'git'

; ;; Define a variant of GDB without a dependency on Guile.
; (define gdb-sans-guile
;   (package
;     (inherit gdb)
;     (inputs (modify-inputs (package-inputs gdb)
;               (delete "guile")))))

; ;; Return a manifest containing that one package plus Git.
; (packages->manifest (list gdb-sans-guile git))


(define mips-linux-gnu-test
    (package
        (inherit binutils)
        (arguments
            (list
                #:configure-flags #~'(
                    "--target=mips-linux-gnu"
                    "--disable-multilib"
                    "--with-gnu-as"
                    "--with-gnu-ld"
                    "--disable-nls"
                    "--enable-plugins"
                    "--enable-deterministic-archives")
                #:make-flags #~'("MAKEINFO=true")))))

(define liblzma 
    (package
        (name "liblzma")
        (version "5.6.4")
        (source (origin
                (method url-fetch)
                (uri (string-append "https://github.com/tukaani-project/xz/releases/download/v" version "/xz-" version ".tar.gz"))
                (sha256
                (base32
                    "16z0yp6rlqnvqvnirjgmihab59wrq56h30lrhha37g9ca4p3z7i6"))))
        (build-system gnu-build-system)
        (synopsis "XZ Utils")
        (description "XZ Utils is free general-purpose data compression software with a high compression ratio.")
        (home-page "https://tukaani.org/xz/")
        (license gpl2+)))

(define local-packages
    (packages->manifest
        (list
            liblzma
            mips-linux-gnu-test)))

(define searched-packages
    (specifications->manifest
        (list
            ;; base packages
            "bash-minimal"
            "glibc-locales"
            "nss-certs"

            ;; Common command line tools lest the container is too empty.
            "coreutils"
            "findutils"
            "grep"
            "which"
            "wget"
            "sed"
            "tar"
            "gzip"

            "git"
            "texinfo"
            "which"
            "make"
            "pkg-config"
            "curl"
            "gcc-toolchain@14.2.0"
            "python"
            "python-pip"
            "python-virtualenv"
            "libpng"
            "libxml++@5.0.3"
            "libxml2-xpath0")))

(define all-packages
    (concatenate-manifests
        (list
            searched-packages
            local-packages)))

; (define my-packages2)
;     (append
;         (list
;             (packages->manifest
;                 (list liblzma))
;             (my-packages1->entries)))
; (packages->manifest (list liblzma python))

; (packages->manifest (list liblzma))
all-packages