(require 'package)                   

;; A list of package repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

;; Initializes the package system and prepares it to be used
(package-initialize)                 

;; Unless a package archive already exists,
(unless package-archive-contents
  ;; Refresh package contents so that Emacs knows which packages to load
  (package-refresh-contents))        


;; Initialize use-package on non-linux platforms
;; Unless "use-package" is installed, install "use-package"
(unless (package-installed-p 'use-package)      
  (package-install 'use-package))

;; Once it's installed, we load it using require
(require 'use-package)                            

;; Make sure packages are downloaded and installed before they are run
;; also frees you from having to put :ensure t after installing EVERY PACKAGE.
(setq use-package-always-ensure t)

;; (unless (package-installed-p 'lsp-mode)
;;   (package-refresh-contents)
;;   (package-install 'lsp-mode))

;; (unless (package-installed-p 'company)
;;   (package-install 'company))

;; (unless (package-installed-p 'company-lsp)
;;   (package-install 'company-lsp))

;; (require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)

;; (require 'lsp-mode)
;; (add-hook 'lsp-mode-hook
;;           (lambda ()
;;             (setq company-backends '((company-lsp :with company-capf)))))

;; (add-hook 'lisp-mode-hook #'lsp)

(use-package lsp-mode
  :ensure t
  ;; :commands lsp
  :bind (:map lsp-mode-map
              ("C-c l" . lsp-command-map)
              ("C-c d" . lsp-describe-thing-at-point)
              ("C-c C-c" . sly-eval-defun))
  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-tcp-connection-timeout 120)
  (setq lsp-language-id-configuration
  '((lisp-mode . "lisp")))  ;; Specify the language ID for lisp-mode

  (add-hook 'lisp-mode-hook #'lsp)  ;; Enable lsp for lisp-mode
  (add-hook 'after-init-hook 'global-company-mode)
  )

;; (use-package orderless
;;   :ensure t
;;   :init
;;   :config
;;   (setq completion-styles '(orderless))
;;   )

;; (use-package compat
;;   :ensure t
;;  :init)

;; (use-package marginalia
;;   :ensure t
;;   :init)
;; (marginalia-mode t)

(use-package winum
  :ensure t
  :config
  (global-set-key (kbd "M-0") 'treemacs-select-window)
  (global-set-key (kbd "M-1") 'winum-select-window-1)
  (global-set-key (kbd "M-2") 'winum-select-window-2)
  (global-set-key (kbd "M-3") 'winum-select-window-3)
  (global-set-key (kbd "M-4") 'winum-select-window-4)
  (global-set-key (kbd "M-5") 'winum-select-window-5)
  (winum-mode))

(line-number-mode 1)
(column-number-mode 1)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(set-frame-parameter (selected-frame) 'alpha '(97 .100))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

(setq electric-pair-pairs '(
                            (?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")
                            ))
(electric-pair-mode t)

(setq display-time-24hr-format t)
(setq display-time-format "%H:%M - %d %B %Y")
(display-time-mode 1)

;; (use-package async
;;   :ensure t
;;   :init (dired-async-mode 1))

(use-package fancy-battery
  :ensure t
  :config
  (setq fancy-battery-show-percentage t)
  (setq battery-update-interval 15)
  (if window-system
      (fancy-battery-mode)
    (display-battery-mode)))

(global-set-key (kbd "C-c n") 'tab-bar-new-tab)
(global-set-key (kbd "C-c m") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "C-c l") 'tab-bar-rename-tab)

(defun toggle-window-split ()
  "Toggle window split from vertical to horizontal and viceverza"
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "C-x M-r") 'toggle-window-split)

;; (use-package embark
;;   :ensure t)
;; (setq prefix-help-command #'embark-prefix-help-command)

(setq inhibit-startup-message t)
;;(set-face-attribute 'default nil :height 180)

(setq python-remove-cwd-from-path nil)

;; (use-package hungry-delete
;;   :ensure t
;;   :config (global-hungry-delete-mode))

;; (use-package sudo-edit
;;   :ensure t
;;   :bind ("M-e" . sudo-edit))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 10)
                          (bookmarks . 10)))
  (setq dashboard-banner-logo-title "Hello Emacs"))
;;(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; (use-package spaceline
;;   :ensure t
;;   :config
;;   (require 'spaceline-config)
;;   (setq powerline-default-separator (quote arrow))
;;   (spaceline-spacemacs-theme)
;;  )

;; (use-package diminish
;;   :ensure t)
;; ;  :init
;; ;  (diminish 'which-key-mode)
;; ;  (diminish 'linum-relative-mode)
;; ;  (diminish 'hungry-delete-mode)
;; ;  (diminish 'visual-line-mode)
;; ;  (diminish 'subword-mode)
;; ;  (diminish 'beacon-mode)
;; ;  (diminish 'irony-mode)
;; ;  (diminish 'page-break-lines-mode)
;; ;  (diminish 'auto-revert-mode)
;; ;  (diminish 'rainbow-delimiters-mode)
;; ;  (diminish 'rainbow-mode)
;; ;  (diminish 'yas-minor-mode)
;; ;  (diminish 'flycheck-mode)
;; ;  (diminish 'helm-mode))

;; (use-package dmenu
;;   :ensure t
;;   :bind
;;   ("C-x d" . 'dmenu))

(use-package symon
  :ensure t
  :bind
  ("C-c h" . symon-mode))
(require 'symon)

(use-package swiper
  :ensure t
  :bind ("C-s" . swiper))

;; (use-package which-key
;;   :ensure t
;;   :init
;;   (which-key-mode))

;; (use-package beacon
;;   :ensure t
;;   :init
;;   (beacon-mode 1))

(setq org-ellipsis " ")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-confirm-babel-evaluate nil)
(setq org-export-with-smart-quotes t)
(setq org-src-window-setup 'current-window)
(add-hook 'org-mode-hook 'org-indent-mode)

(setq org-structure-template-alist
      '(("a" . "export ascii\n")
        ("c" . "center\n")
        ("C" . "comment\n")
        ("e" . "example\n")
        ("E" . "export")
        ("h" . "export html\n")
        ("l" . "export latex\n")
        ("q" . "quote\n")
        ("s" . "src\n")
        ("v" . "verse\n")))

(global-set-key (kbd "C-c '") 'org-edit-src-code)
(global-set-key (kbd "C-c s i") 'org-toggle-pretty-entities)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode))))

(global-set-key (kbd "C-c v") 'org-babel-remove-result)

;;  (global-set-key (kbd "C-c C-x \") 'org-toggle-pretty-entities)

;; (setq ido-enable-flex-matching nil)
;; (setq ido-create-new-buffer 'always)
;; (setq ido-everywhere nil)
;; (ido-mode 1)

;; (use-package ido-vertical-mode
;;   :ensure t
;;   :init
;;   (ido-vertical-mode 1))
;; (setq ido-vertical-define-keys 'C-n-and-C-p-only)

;; (use-package smex
;;   :ensure t
;;   :init (smex-initialize)
;;   :bind
;;   ("M-x" . smex))

(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)

(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
(global-set-key (kbd "C-M-z") 'kill-all-buffers)

(defun kill-curr-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'kill-curr-buffer)

;  (global-set-key (kbd "C-x b") 'ibuffer)

;; (use-package avy
;;   :ensure t
;;   :bind
;;   ("M-s" . avy-goto-char))

(use-package ivy
  :init
  (ivy-mode 1)
  :bind (("C-s" . swiper)
         ("C-x b" . counsel-switch-buffer)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("M-j" . ivy-next-line)
         ("M-k" . ivy-previous-line)
         ("C-d" . ivy-switch-buffer-kill))
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-truncate-lines t)
  (ivy-wrap t)
  (ivy-use-selectable-prompt t)
  (ivy-count-format "[%d/%d]")
  (enable-recursive-minibuffers t)
  (max-lisp-eval-depth 5000))

(use-package ivy-posframe
  :ensure t
  ;;:diminish
  :after ivy
  :custom
  (ivy-posframe-width 130)
  (ivy-posframe-height 10)
  (ivy-posframe-border-width 2)
  :config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
  (ivy-posframe-mode 1))

(use-package counsel
  :after ivy
  :bind
  (("C-x f" . counsel-recentf))
  :config (counsel-mode 1))

(defun copy-whole-line ()
  (interactive)
  (save-excursion
    (kill-new
     (buffer-substring
      (point-at-bol)
      (point-at-eol)))))
(global-set-key (kbd "C-c w l") 'copy-whole-line)

(defun kill-whole-word ()
  (interactive)
  (backward-word)
  (kill-word 1))
(global-set-key (kbd "C-c w w") 'kill-whole-word)

(defun config-visit ()
  (interactive)
  (find-file "~/.emacs.d/config.org"))
(global-set-key (kbd "C-c e") 'config-visit)

(defun config-reload ()
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))
(global-set-key (kbd "C-c r") 'config-reload)

;; (use-package rainbow-mode
;;   :ensure t
;;   :init (add-hook 'prog-mode-hook 'rainbow-mode))

(show-paren-mode 1)

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  (setq switch-window-shorcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l"))
  :bind
  ([remap other-window] . switch-window))

;; (use-package linum-relative
;;   :ensure t
;;   :config
;;   (setq linum-relative-current-symbol "")
;;   (add-hook 'prog-mode-hook 'linum-relative-mode))

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(use-package mark-multiple
  :ensure t
  :bind ("C-c q" . 'mark-all-like-this))

;; (use-package yasnippet
;;   :ensure t
;;   :config
;;   (use-package yasnippet-snippets
;;     :ensure t)
;;   (yas-reload-all))
;; (add-hook 'python-mode-hook 'yas-minor-mode)
;; (add-hook 'org-mode-hook 'yas-minor-mode)
;; ;;(add-hook 'elisp-mode-hook 'yas-minor-mode)
;; (add-hook 'clisp-mode-hook 'yas-minor-mode)
;; (add-hook 'sql-mode-hook 'yas-minor-mode)

;; (use-package flycheck
;;   :ensure t
;;   :hook ((python-mode) . flycheck-mode))

;;(global-set-key (kbd "TAB") 'company-complete-common)
;(global-set-key (kbd "M-h") #'company-other-backend)
;(global-set-key (kbd "M-y") 'company-yasnippet)
;(use-package company-box
 ; :hook (company-mode . company-box-mode))

;(use-package company
  ;:diminish company-mode
  ;; :hook
  ;; (after-init-hook . global-company-mode)
  ;; :bind
  ;; (:map company-active-map
  ;;       ("C-n"    . nil)
  ;;       ("C-p"    . nil)
  ;;       ("M-j"    . company-select-next)
  ;;       ("M-k"    . company-select-previous)
  ;;       ("C-s"    . company-filter-candidates)
  ;;       ("TAB"    . company-complete-common-or-circle)
  ;;       ("<f1>"   . nil))
  ;; (:map company-search-map ; applies to company-filter-map too
  ;;       ("C-n"    . nil)
  ;;       ("C-p"    . nil)
  ;;       ("M-j"    . company-select-next-or-abort)
  ;;       ("M-k"    . company-select-previous-or-abort)
  ;;       ("C-s"    . company-filter-candidates)
  ;;       ([escape] . company-search-abort))
  ;; :init
  ;; (setq company-tooltip-align-annotations nil
  ;;       company-tooltip-limit 12
  ;;       company-minimun-prefix-length 1
  ;;       company-idle-delay 0.1
  ;;       company-echo-delay 0
  ;;       company-show-numbers nil
  ;;       company-require-match nil
  ;;       company-selection-wrap-around t
  ;;       company-dabbrev-ignore-case t
  ;;       company-dabbrev-downcase t)
  ;; :ensure t
  ;; :config
  ;; (setq company-backends
  ;;       '((company-capf
  ;;          company-yasnippet
  ;;          company-files
  ;;          company-dabbrev
  ;;          company-dabbrev-code
  ;;          company-gtags
  ;;          company-etags
  ;;          company-keywords)))
  ;; )

;; (use-package corfu
;;   :custom
;;   (corfu-cycle t) ;
;;   (corfu-auto t)
;;   (corfu-auto-prefix 2)
;;   (corfu-auto-delay 0.0)
;;   (corfu-quit-at-boundary 'separator)
;;   (corfu-echo-documentation 0.25)
;;   (corfu-preview-current 'insert)
;;   (corfu-preselect-first nil)

;;   :bind (:map corfu-map
;;               ("M-SPC" . corfu-insert-separator)
;;               ("RET" . nil)
;;               ("TAB" . corfu-next)
;;               ([tab] . corfu-next)
;;               ("S-TAB" . corfu-previous)
;;               ([backtab] . corfu-previous)
;;               ("S-<return>" . corfu-insert)
;;               )
;;   :init
;;   (global-corfu-mode)
;;   (corfu-history-mode)
;;   (corfu-echo-mode)
;;   :config
;;   (add-hook 'eshell-mode-hook
;;             (lambda () (setq-local corfu-quit-at-boundary t
;;                                    corfu-quit-no-match t
;;                                    corfu-auto nil)
;;               (corfu-mode))))

;; (add-hook 'eshell-mode-hook
;;           (lambda ()
;;             (setq-local corfu-auto nil)
;;             (corfu-mode)))

;; (add-hook 'c++-mode-hook 'yas-minor-mode)
;; (add-hook 'c-mode-hook 'yas-minor-mode)

;; (use-package flycheck-clang-analyzer
;;   :ensure t
;;   :config
;;   (with-eval-after-load 'flycheck
;;     (require 'flycheck-clang-analyzer)
;;     (flycheck-clang-analyzer-setup)))

;; (with-eval-after-load 'company
;;   (add-hook 'c++-mode-hook 'company-mode)
;;   (add-hook 'c-mode-hook 'company-mode))

;; (use-package company-c-headers
;;   :ensure t)

;; (use-package company-irony
;;   :ensure t
;;   :config
;;   (setq company-backends '((company-c-headers
;; 			    company-dabbrev-code
;; 			    company-irony))))

;; (use-package irony
;;   :ensure t
;;   :config
;;   (add-hook 'c++-mode-hook 'irony-mode)
;;   (add-hook 'c-mode-hook 'irony-mode)
;;   (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(setq python-shell-interpreter "python3")
;;(require 'python-mode)
(with-eval-after-load 'python
  (define-key python-mode-map (kbd "C-c C-c")
    (lambda () (interactive) (python-shell-send-buffer t))))

;;(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
  ;;(add-hook 'emacs-lisp-mode-hook 'yas-minor-mode)
  ;;(add-hook 'emacs-lisp-mode-hook 'company-mode)

(unless (package-installed-p 'sly)
  (package-refresh-contents)
  (package-install 'sly))

(setq sly-history-file "~/.sly-mrepl-history")
(setq sly-history-size 1000)

(require 'sly)

;; (use-package slime
;;   :ensure t
;;   :config
;;   (setq inferior-lisp-program "/usr/bin/sbcl")
;;   (setq slime-contribs '(slime-fancy)))

      ;; ;(load "/usr/share/common-lisp/source/quicklisp/quicklisp.lisp"

;; (use-package slime-company
;;   :ensure t
;;   :init
;;   (require 'company)
;;   (slime-setup '(slime-fancy slime-company)))

(use-package scala-mode
  :interpreter
  ("scala" . scala-mode))

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

(use-package magit
  :ensure t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind
  ("M-g" . magit-status))

(global-set-key (kbd "C-c w s") 'forward-whitespace)
(global-set-key (kbd "C-c t i") 'forward-to-indentation)

(fset 'do-loop
 (kmacro-lambda-form [?\C-c ?w ?s ?\C-k ?: ?= ?  ?c ?. ?\M-m ?\C-\M-  ?\M-w ?\C-e ?\C-y ?\; ?\C-c ?t ?i] 0 "%d"))
(global-set-key (kbd "C-c d l") 'do-loop)

(use-package elfeed
  :ensure t
  :bind (:map elfeed-search-mode-map
              ("q" . bjm/elfeed-save-db-and-bury)
              ("Q" . bjm/elfeed-save-db-and-bury)
              ("j" . mz/make-and-run-elfeed-hydra)
              ("m" . elfeed-toggle-star)
              ("J" . mz/make-and-run-elfeed-hydra)
              ("M" . elfeed-toggle-star)
              )
  )

(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))
  (setq org-hide-leading-stars t)
  )

;; Load elfeed-org
(require 'elfeed-org)

;;(use-package clippy
;; :ensure t)

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  )

(add-to-list 'load-path (concat user-emacs-directory "marginalia/" ))
(load "marginalia")
(marginalia-mode)
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;;`completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be actived in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(global-set-key (kbd "C-c b") 'eww-list-bookmarks)

(setq browse-url-browser-function 'eww-browse-url)

(defvar-local endless/display-images t)

(defun endless/toggle-image-display ()
  "Toggle images display on current buffer."
  (interactive)
  (setq endless/display-images
        (null endless/display-images))
  (endless/backup-display-property endless/display-images))

(defun endless/backup-display-property (invert &optional object)
  "Move the 'display property at POS to 'display-backup.
Only applies if display property is an image.
If INVERT is non-nil, move from 'display-backup to 'display
instead.
Optional OBJECT specifies the string or buffer. Nil means current
buffer."
  (let* ((inhibit-read-only t)
         (from (if invert 'display-backup 'display))
         (to (if invert 'display 'display-backup))
         (pos (point-min))
         left prop)
    (while (and pos (/= pos (point-max)))
      (if (get-text-property pos from object)
          (setq left pos)
        (setq left (next-single-property-change pos from object)))
      (if (or (null left) (= left (point-max)))
          (setq pos nil)
        (setq prop (get-text-property left from object))
        (setq pos (or (next-single-property-change left from object)
                      (point-max)))
        (when (eq (car prop) 'image)
          (add-text-properties left pos (list from nil to prop) object))))))

(global-set-key (kbd "C-c ,") 'endless/toggle-image-display)

(setq inferior-lisp-program "/usr/bin/sbcl")

;; Load ESS
;;(require 'ess-site)

(add-to-list 'load-path (concat user-emacs-directory "pyvenv/" ))
(load "pyvenv")
;;  (add-to-list 'load-path (concat user-emacs-directory "virtualenvwrapper/" ))
;;  (load "virtualenvwrapper")

;; (straight-use-package
    ;;  '(mu4e :files (:defaults "mu4e/*.el")))
    ;;   (use-package mu4e
    ;;     :ensure t
    ;;      :init)
;; (setq +mu4e-backend 'offlineimap)
;;   (set-email-account! "Lissner.net"
;;     '((mu4e-sent-folder       . "/Lissner.net/Sent Mail")
;;       (mu4e-drafts-folder     . "/Lissner.net/Drafts")
;;       (mu4e-trash-folder      . "/Lissner.net/Trash")
;;       (mu4e-refile-folder     . "/Lissner.net/All Mail")
;;       (smtpmail-smtp-user     . "henrik@lissner.net")
;;       (user-mail-address      . "henrik@lissner.net")    ;; only needed for mu < 1.4
;;       (mu4e-compose-signature . "---\nHenrik Lissner"))
;;     t)

(use-package pydoc
  :ensure t
  :init)

;;(add-to-list 'load-path (concat user-emacs-directory "python-django.el"))
(add-to-list 'load-path "~/.emacs.d/python-django.el")
(require 'python-django)

(defun pydoc (name)
  "Display pydoc information for NAME in a buffer named *pydoc*"
  (interactive "sName of function or module: ")
  (switch-to-buffer-other-window "*pydoc")
  (erase-buffer)
  (insert (shell-command-to-string (format "python -m pydoc %s" name)))
  (goto-char (point-min)))
;;(add-to-list 'load-path (concat user-emacs-directory "python-django.el"))
;;(add-to-list 'load-path "~/.emacs.d/pydoc-info.el")
;;(require 'pydoc-info)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/magit")
    (setq projectile-project-search-path '("~/magit")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))
(setq debug-on-error t)

(unless (package-installed-p 'visual-fill-column)
        (package-install 'visual-fill-column))

      (setq visual-fill-column-width 110
            visual-fill-column-center-text t)

      (defun my/org-present-start ()

        (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                           (header-line (:height 4.0) variable-pitch)
                                           (org-document-title (:height 1.75) org-document-title)
                                           (org-code (:height 1.55) org-code)
                                           (org-verbatim (:height 1.55) org-verbatim)
                                           (org-block (:height 1.25) org-block)
                                           (org-block-begin-line (:height 0.7) org-block)))

        ;; Set a blank header line string to create blank space at the top
        (setq header-line-format " ")

        ;;center the presentation and wrap lines
        (visual-fill-column-mode 1)
        (visual-line-mode 1))

      (defun my/org-present-end ()
        ;;Reset font custommizations
        (setq-local face-remapping-alist '((dafault variable-pitch default)))

        ;; Set a blank header line string to create blank space at the top
        (setq header-line-format nil)

        (visual-fill-column-mode 0)
        (visual-line-mode 0))

      (add-hook 'org-present-mode-hook 'my/org-present-start)
      (add-hook 'org-present-mode-quit-hook 'my/org-present-end)

     ;; (set-face-attribute 'default nil :font "JetBrains Mono" :weight 'light :height 80)
     ;; (set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :weight 'light :height 90)
     ;; (set-face-attribute 'variable-pitch nil :font "Iosevka Aile" :weight 'light :height 1.3)


      ;; Load org-faces to make sure we can set appropiate faces
      (require 'org-faces)

      ;; Hide emphasis markers on formatted text
      (setq org-hide-emphasis-markers t)

      ;; Resize Org headings
;;      (dolist (face '((org-level-1 . 1.2)
;;                      (org-level-2 . 1.1)
;;                      (org-level-3 . 1.05)
;;                      (org-level-4 . 1.0)
;;                      (org-level-5 . 1.1)
;;                      (org-level-6 . 1.1)
;;                      (org-level-7 . 1.1)
;;                      (org-level-8 . 1.1)))
 ;;       (set-face-attribute (car face) nil :font "Iosevka Aile" :weight 'medium :height (cdr face)))

      ;; Make the document title a bit bigger
;;      (set-face-attribute 'org-document-title nil :font "Iosevka Aile" :weight 'bold :height 1.3)

      ;; Make sure certain org faces use the fixed-pitch face when variable-pitch-mode is on
      (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
      (set-face-attribute 'org-table nil :inherit 'fixed-pitch)  
      (set-face-attribute 'org-formula nil :inherit 'fixed-pitch)
      (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))  
      (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

      (defun my/org-present-prepare-slide (buffer-name heading)

        ;; Show only top level headlines
        (org-overview)

        ;; Unfold the current entry
        (org-show-entry)

        ;; Show only direct subheadings of the slide but don't expand them
        (org-show-children))

      (add-hook 'org-present-after-navigate-functions 'my/org-present-prepare-slide)

      (use-package doom-themes
        :ensure t
        :init)

  (load-theme 'doom-oksolar-dark t)
    ;;(load-theme 'doom-sourcerer t)
      ;;(load-theme 'doom-palenight t)

;;(define-key python-mode-map (kbd "C-c i") 'elpygen-implement)

;; (custom-set-variables
;;  '(jdee-server-dir "~/work/java/myJars"))

;; (require 'eclim)
;; (setq eclimd-autostart t)

;; (defun my-java-mode-hook ()
;;     (eclim-mode t))

;; (add-hook 'java-mode-hook 'my-java-mode-hook)

;; (require 'lsp-java)
;; (add-hook 'java-mode-hook #'lsp)


;; ;; (setq eclim-executable "~/.emacs.d/elpa/eclim-20181108.1134/")
;; (custom-set-variables
;;   '(eclim-eclipse-dirs '("/opt/eclipse/eclipse/"))
;;   ;; '(eclim-executable "~/.emacs.d/elpa/eclim-20181108.1134/")
;; )

;; (use-package projectile)
;; (use-package flycheck)
;; (use-package yasnippet :config (yas-global-mode))
;; (use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration)))
;; (use-package hydra)
;; (use-package company)
;; (use-package lsp-ui)
;; (use-package which-key :config (which-key-mode))
;; (use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
;; (use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
;; (use-package dap-java :ensure nil)
;; (use-package helm-lsp)
;; (use-package helm
;;   :config (helm-mode))
;; (use-package lsp-treemacs)

;;   (with-eval-after-load 'js
;;     (define-key js-mode-map (kbd "M-.") nil))

;; (helm-mode)
;; (require 'helm-xref)
;; (define-key global-map [remap find-file] #'helm-find-files)
;; (define-key global-map [remap execute-extended-command] #'helm-M-x)
;; (define-key global-map [remap switch-to-buffer] #'helm-mini)
;; (which-key-mode)
;; (add-hook 'prog-mode-hook #'lsp)
;; (setq gc-cons-threshold (* 100 1024 1024)
;;       read-process-output-max (* 1024 1024)
;;       company-idle-delay 0.0
;;       company-minimum-prefix-length 1
;;       create-lockfiles nil) ;; lock files will kill `npm start'
;; (with-eval-after-load 'lsp-mode
;;   (require 'dap-chrome)
;;   (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
;;   (yas-global-mode))

;; (add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode)) ;; auto-enable for .js/.jsx files
;; (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))

;; (require 'flycheck)

;; (setq-default flycheck-disabled-checkers
;;               (append flycheck-disabled-checkers
;;                       '(javascript-jshint json-jsonlist)))
;; (add-hook 'flycheck-mode-hook 'add-node-modules-path)
;; (add-hook 'web-mode-hook  'emmet-mode)
