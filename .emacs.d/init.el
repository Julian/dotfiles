; === Basic ===
(global-hl-line-mode 1)

; === Plugins ===

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
    'package-archives
    '("melpa" . "http://melpa.org/packages/")
    t)
  (package-initialize))

(if (not (package-installed-p 'use-package))
  (progn
    (package-refresh-contents)
    (package-install 'use-package)))

(require 'use-package)
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

(use-package evil)
(use-package evil-args)
(use-package evil-exchange)
(use-package evil-surround)

(require 'evil)
(evil-mode 1)
