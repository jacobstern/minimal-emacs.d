;;; post-init.el --- Post Init  -*- no-byte-compile: t; lexical-binding: t; -*-

(add-hook 'after-init-hook #'electric-pair-mode)
(add-hook 'after-init-hook #'global-hl-line-mode)

;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(add-hook 'after-init-hook #'global-auto-revert-mode)

;; recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(add-hook 'after-init-hook #'recentf-mode)

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(add-hook 'after-init-hook #'savehist-mode)

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(add-hook 'after-init-hook #'save-place-mode)

(pixel-scroll-precision-mode)

(use-package gcmh
  :straight t
  :hook (after-init . gcmh-mode)
  :custom
  (gcmh-idle-delay 'auto)
  (gcmh-auto-idle-delay-factor 10)
  (gcmh-low-cons-threshold minimal-emacs-gc-cons-threshold))

(setq ns-command-modifier 'control)
(setq ns-control-modifier 'super)

(file-name-shadow-mode 1)

(setq delete-by-moving-to-trash t)
(setq dired-dwim-target t)
(setq dired-deletion-confirmer #'y-or-n-p)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package emacs
  :ensure nil
  :init
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  (add-hook 'text-mode-hook #'display-line-numbers-mode)
  (add-hook 'conf-mode-hook #'display-line-numbers-mode)

  ;; Tree-Sitter config
  (setq treesit-language-source-alist
        '((javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
  :bind
  (("C-c f" . #'project-find-file)
   ("C-c r" . #'recentf)
   ("C-c o" . #'mode-line-other-buffer)
   ("C-x C-b" . #'ibuffer)))

(use-package eglot
  :hook ((js-ts-mode jsx-ts-mode typescript-ts-mode tsx-ts-mode json-ts-mode css-ts-mode) . eglot-ensure)
  :ensure nil
  :defer t
  :commands (eglot
             eglot-rename
             eglot-ensure
             eglot-rename
             eglot-format-buffer)
  :custom
  (eglot-report-progress nil)  ; Prevent minibuffer spam
  :config
  ;; Optimizations
  (fset #'jsonrpc--log-event #'ignore)
  (setq jsonrpc-event-hook nil)
  :bind
  (:map eglot-mode-map
        ("C-c x a" . #'eglot-code-actions)
        ("C-c x r" . #'eglot-rename)
        ("C-c x q" . #'eglot-code-action-quickfix)
        ("C-c x y" . #'eglot-find-typeDefinition)))

(use-package vim-tab-bar
  :straight t
  :commands vim-tab-bar-mode
  :hook
  (after-init . vim-tab-bar-mode))

(use-package catppuccin-theme
  :straight t
  :init
  (setq catppuccin-flavor 'latte)
  :config
  (load-theme 'catppuccin :no-confirm))

(use-package vertico
  ;; (Note: It is recommended to also enable the savehist package.)
  :straight t
  :custom
  (vertico-cycle t)
  (vertico-height 13)
  (vertico-resize nil)
  (vertico-multiform-commands '((consult-imenu buffer indexed)))
  :defer t
  :commands vertico-mode
  :hook (after-init . vertico-mode))

(use-package diminish
  :straight t
  :demand t)

(use-package apheleia
  :straight t
  :custom
  ;; https://emacs.stackexchange.com/questions/70367/how-can-i-apply-diminish-to-apheleia-mode?rq=1
  (apheleia-mode-lighter nil)
  :init
  (apheleia-global-mode +1))

(use-package orderless
  ;; Vertico leverages Orderless' flexible matching capabilities, allowing users
  ;; to input multiple patterns separated by spaces, which Orderless then
  ;; matches in any order against the candidates.
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  ;; Marginalia allows Embark to offer you preconfigured actions in more contexts.
  ;; In addition to that, Marginalia also enhances Vertico by adding rich
  ;; annotations to the completion candidates displayed in Vertico's interface.
  :straight t
  :defer t
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

(use-package embark
  ;; Embark is an Emacs package that acts like a context menu, allowing
  ;; users to perform context-sensitive actions on selected items
  ;; directly from the completion interface.
  :straight t
  :defer t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :straight t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

(use-package corfu
  :ensure t
  :straight t
  :commands (corfu-mode global-corfu-mode)

  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))

  :bind
  ("s-SPC" . #'completion-at-point)

  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)

  ;; Enable Corfu
  :config
  (global-corfu-mode))

(use-package vterm
  :ensure t
  :defer t
  :commands vterm
  :bind
  ("C-c t" . #'vterm-other-window)
  :config
  ;; Speed up vterm
  (setq vterm-timer-delay 0.01))

(use-package cape
  :straight t
  :defer t
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package magit
  :ensure t
  :straight t
  :bind
  ("C-x g" . #'magit-status)
  ("C-c g" . #'magit-dispatch))

(use-package eldoc
  :init
  ;; (setq eldoc-echo-area-use-multiline-p nil)
  ;; (setq eldoc-echo-area-display-truncation-message nil)
  (setq eldoc-echo-area-prefer-doc-buffer t))

(use-package markdown-mode
  :straight t)

;; https://www.rahuljuliato.com/posts/eslint-on-emacs
(defun lemacs/use-local-eslint ()
  "Set project's `node_modules' binary eslint as first priority.
    If nothing is found, keep the default value flymake-eslint set or
    your override of `flymake-eslint-executable-name.'"
  (interactive)
  (let* ((root (locate-dominating-file (buffer-file-name) "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/.bin/eslint"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flymake-eslint-executable-name eslint)
      (message (format "Found local ESLINT! Setting: %s" eslint))
      (flymake-eslint-enable))))

(use-package flymake-eslint
  :straight t
  :config
  (setq flymake-eslint-prefer-json-diagnostics t)
  :hook
  (eglot-managed-mode . (lambda ()
                          (when (derived-mode-p 'typescript-ts-mode 'tsx-ts-mode 'js-ts-mode)
                            (lemacs/use-local-eslint)))))
