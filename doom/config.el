;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;(setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15.0 :weight 'medium))

;; center cursor when scroll up and down
(map! :n "C-d" (cmd! (evil-scroll-down 0) (evil-scroll-line-to-center nil))
      :n "C-u" (cmd! (evil-scroll-up 0)   (evil-scroll-line-to-center nil)))

;; center cursor when navigating through search matches
;; (map! :n "n" (cmd! (evil-search-word-forward) (evil-scroll-line-to-center nil))
;;       :n "N" (cmd! (evil-search-word-backward) (evil-scroll-line-to-center nil)))

;; center cursor when navigating through word under cursor matches
;; (map! :n "*" (cmd! (evil-search-word-forward) (evil-scroll-line-to-center nil))
;;       :n "#" (cmd! (evil-search-word-backward) (evil-scroll-line-to-center nil)))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq
 org-directory "~/org/"
 projectile-project-search-path '("~/Desktop/leisure/" "~/Desktop/Work/" "~/Desktop/Work/repos/gcoach/"))

;; resize window
(use-package! hydra
  :defer
  :config
  (defhydra hydra/evil-window-resize (:color red)
    "Resize window"
    ("h" evil-window-decrease-width "decrease width")
    ("j" evil-window-decrease-height "decrease height")
    ("k" evil-window-increase-height "increase height")
    ("l" evil-window-increase-width "increase width")
    ("q" nil "quit")))
(map! :leader
      :prefix ("w" . "window")
      :n "r" #'hydra/evil-window-resize/body)

;; run python

(defun my-run-python-venv ()
  "Save buffer and run with project's .venv python."
  (interactive)
  (when buffer-file-name
    (save-buffer)
    ;; 1. Determine project root
    (let* ((root (doom-project-root))
           ;; 2. Construct path to python executable
           (venv-python (expand-file-name ".venv/bin/python3" root))
           ;; 3. Get file path relative to root (optional, makes output cleaner)
           (file-path (file-relative-name buffer-file-name root)))

      ;; 4. Check if venv exists before running
      (if (file-executable-p venv-python)
          (let ((default-directory root)) ;; Run command from project root
            (compile (format "%s %s" venv-python file-path)))
        (message "Error: Could not find .venv/bin/python3 in %s" root)))))

(defun uv-activate ()
  "Activate Python environment managed by uv, with Doom Modeline support."
  (interactive)
  (let* ((project-root (project-root (project-current t)))
         (venv-path (expand-file-name ".venv" project-root))
         (python-path (expand-file-name
                       (if (eq system-type 'windows-nt)
                           "Scripts/python.exe"
                         "bin/python")
                       venv-path)))
    (if (file-exists-p python-path)
        (progn
          ;; 1. Set the interpreter
          (setq python-shell-interpreter python-path)
          (setq python-shell-virtualenv-root venv-path) ;; HELPS DOOM DETECT VENV

          ;; 2. Set the Mode-Line Indicator
          ;; By default, Doom shows the folder name (which is always ".venv").
          ;; We override this to show the PROJECT name instead (e.g., "my-api").
          (setq-local venv-current-name
                      (file-name-nondirectory (directory-file-name project-root)))

          ;; 3. Update exec-path (Emacs internal path)
          (let ((venv-bin-dir (file-name-directory python-path)))
            (setq exec-path (cons venv-bin-dir
                                  (remove venv-bin-dir exec-path))))

          ;; 4. Update Environment Variables (Sub-processes)
          (setenv "PATH" (concat (file-name-directory python-path)
                                 path-separator
                                 (getenv "PATH")))
          (setenv "VIRTUAL_ENV" venv-path)
          (setenv "PYTHONHOME" nil)

          (message "Activated uv venv for %s" venv-current-name))
      (message "No .venv found in %s" project-root))))

(add-hook! '(python-mode-hook python-ts-mode-hook) #'uv-activate)
;; Keybinding using Doom's map! macro
(map! :after python           ; Only load this when python loads
      :map (python-mode-map python-ts-mode-map)    ; Bind only in python buffers
      :localleader            ; Uses 'SPC m' (or 'C-c' in holy mode)
      :desc "Run Venv" "r" #'my-run-python-venv)

;; ######## ty as Python LSP begin

;; 1. Project Management: Teach Emacs to recognize pyproject.toml as a project root
(defun my-project-find-python-project (dir)
  (when-let ((root (locate-dominating-file dir "pyproject.toml")))
    (cons 'python-project root)))

(after! project
  (cl-defmethod project-root ((project (head python-project)))
    (cdr project))
  ;; Add to the front of the list so it takes precedence over generic checks
  (add-hook 'project-find-functions #'my-project-find-python-project nil nil))

;; 2. File Associations: Treat uv.lock as TOML
(add-to-list 'auto-mode-alist '("/uv\\.lock\\'" . toml-ts-mode))

;; 3. Python & Ty Setup
(after! python
  ;; Ensure we use tree-sitter mode for Python (Doom might do this automatically
  ;; if +tree-sitter is on, but this ensures it).
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)))

(after! eglot
  ;; Register 'ty' as the LSP server for Python.
  ;; We use add-to-list to prepend it, ensuring it takes precedence over
  ;; other servers like Pyright or Ruff if they are also installed.
  (add-to-list 'eglot-server-programs
               '((python-ts-mode python-mode)
                 . ("ty" "server"))))

;; 4. Auto-start Eglot in Python
(add-hook! 'python-ts-mode-hook #'eglot-ensure)

;; ######## ty as Python LSP end

;; keybind to open git remote in browser
(map! :leader
      :desc "Open git remote"
      "o g" (cmd! (start-process-shell-command "open_git" nil "open_git")))

;; include undescore in vim keybinds word navigation
(add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
;; (global-superword-mode 1)

;; Auto save org files
(add-hook 'org-mode-hook #'(lambda () (auto-save-visited-mode 1)))

(after! org
  ;; Set the agenda span to exactly 10 days
  (setq org-agenda-span 30))

(setq org-capture-templates
      '(("r" "Re-Zero" entry
         (file+headline "re-zero.org" "Re-Zero")
         "* TODO %^{Project}: %^{Describe todo}%?")
        ("n" "Notes" entry
         (file+headline "notes.org" "Notes")
         "* %?\n SCHEDULED: %t\n")
        ("t" "Tickets" entry
         (file+headline "notes.org" "Tickets")
         "* %^{Project} \n%^{Description}: \n%^{Link}")
        ("p" "Personal Tasks" entry
         (file+headline "married_life.org" "Tasks")
         "* TODO %?")))

(defun my/run-pre-commit-all-files ()
  "Run pre-commit from the local .venv if it exists."
  (interactive)
  (let ((venv-path (concat (doom-project-root) ".venv/")))
    (if (file-directory-p venv-path)
        (let ((default-directory (doom-project-root)))
          (compile ".venv/bin/pre-commit run --all-files"))
      (message "Warning: .venv directory not found in %s" (doom-project-root)))))

(map! :leader
      (:prefix ("p" . "project")
       :desc "Run pre-commit hooks on all files" "h" #'my/run-pre-commit-all-files))

(set-popup-rule! "^\\*Org Src" :side 'right :size 0.5 :select t)

(use-package popper
  :ensure t ; or :straight t
  :bind (("s-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          "^\\*vterm.*\\*$" vterm-mode
          "^\\*eshell.*\\*$" eshell-mode
          "^\\*shell.*\\*$"  shell-mode  ;shell as a popup
          "^\\*term.*\\*$"   term-mode   ;term as a popup
          help-mode
          compilation-mode))
  (setq popper-group-function #'popper-group-by-projectile)
  (popper-mode +1)
  (popper-echo-mode +1))                ; For echo area hints
