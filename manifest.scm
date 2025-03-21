(use-modules (guix packages)
             (guix download)
             (guix build-system gnu)
             (guix licenses))

;; binutils with some extra config flags to target mips-linux-gnu
(define mips-linux-gnu
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

;; custom defined liblzma as its not available in the guix package definitions
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
            mips-linux-gnu)))

(define searched-packages
    (specifications->manifest
        (list
            ;; base packages
            "bash-minimal"
            "glibc-locales"
            "nss-certs"

            ;; CLIs
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

            ;; build things
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

all-packages