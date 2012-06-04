(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window
(when (require 'browse-kill-ring nil 'noerror)
  (browse-kill-ring-default-keybindings))

(global-set-key "\C-cy" '(lambda ()
   (interactive)
   (popup-menu 'yank-menu)))

(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

(load-file "~/emacs/fullscreen.el")
(require 'fullscreen)
;; (add-hook 'window-setup-hook 'maximize-frame t)
;; (setq mf-max-width 1920)
;; (global-set-key (kbd "M-RET") 'mac-toggle-max-window)
;; for latex key-binding
;;
;;(define-key latex-mode-base-map[(f5)] 'tex-file)
;; for shell path
;; 
(defun read-system-path ()
    (with-temp-buffer
          (insert-file-contents "/etc/paths")
              (goto-char (point-min))
                  (replace-regexp "\n" ":")
                      (thing-at-point 'line)))

(setenv "PATH" (read-system-path))


;; for cursor
;; 
(load-file "~/emacs/cursor-chg.el")
(require 'cursor-chg)  ; Load the library
   (toggle-cursor-type-when-idle 1) ; Turn on cursor change when Emacs is idle
   (change-cursor-mode 1) ; Turn on change for overwrite, read-only, and input mode
;; for git
  (add-to-list 'load-path "~/emacs/git/")
  (require 'git)
  (require 'git-blame)
;; for compile
(global-set-key [f1] 'help)
(global-set-key [f5] 'compile)
(global-set-key [f6] 'shell)
(global-set-key [f7] 'switch-to-buffer)
(global-set-key [f4] 'delete-other-windows)
(global-set-key [f3] 'other-window)
(global-set-key [f2] 'dired)
(global-set-key [f9] 'next-error)
(global-set-key [f1] 'help) 
(global-set-key [f11] 'ff-find-other-file)

(defun my-c-mode-common-hook ()
   (define-key c-mode-base-map (kbd "M-o") 'eassist-switch-h-cpp)
   (define-key c-mode-base-map (kbd "M-m") 'eassist-list-methods))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; copy without selection
  ;; 0. basic function
(defun get-point (symbol &optional arg)
      "get the point"
      (funcall symbol arg)
      (point)
     )
 
     (defun copy-thing (begin-of-thing end-of-thing &optional arg)
       "copy thing between beg & end into kill ring"
        (let ((beg (get-point begin-of-thing 1))
         (end (get-point end-of-thing arg)))
          (copy-region-as-kill beg end))
     )
 
     (defun paste-to-mark(&optional arg)
       "Paste things to mark, or to the prompt in shell-mode"
       (let ((pasteMe 
         (lambda()
           (if (string= "shell-mode" major-mode)
             (progn (comint-next-prompt 25535) (yank))
           (progn (goto-char (mark)) (yank) )))))
        (if arg
            (if (= arg 1)
            nil
              (funcall pasteMe))
          (funcall pasteMe))
        )) 
 ;; 1. copy word
(defun copy-word (&optional arg)
      "Copy words at point into kill-ring"
       (interactive "P")
       (copy-thing 'backward-word 'forward-word arg)
       (paste-to-mark arg)
     )
(global-set-key (kbd "C-c w")         (quote copy-word))
  ;; 2. copy line
(defun copy-line (&optional arg)
      "Save current line into Kill-Ring without mark the line "
       (interactive "P")
       (copy-thing 'beginning-of-line 'end-of-line arg)
       (paste-to-mark arg)
     )
(global-set-key (kbd "C-c l")         (quote copy-line))
  ;; 3. copy paragraph
(defun copy-paragraph (&optional arg)
      "Copy paragraphes at point"
       (interactive "P")
       (copy-thing 'backward-paragraph 'forward-paragraph arg)
       (paste-to-mark arg)
     )
(global-set-key (kbd "C-c p")         (quote copy-paragraph))

;; default face configuration
(setq mac-allow-anti-aliasing nil)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  ;; 中文测试没有问题, background "gray12"
 '(default ((t (:stipple nil :background "black" :foreground "green" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 200 :width normal :foundry "apple" :family "Courier" :antialias nil)))))
;(add-to-list 'load-path "~/emacs/color-theme-6.6.0/")
;    (require 'color-theme)
;    (color-theme-initialize)
;    (color-theme-retro-green)
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
 (set-frame-parameter (selected-frame) 'alpha '(90 90))
 (add-to-list 'default-frame-alist '(alpha 90 90))
;; code jump
(global-set-key [f12] 'semantic-ia-fast-jump)
(global-set-key [S-f12]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))
(global-set-key [f10] 'semantic-analyze-proto-impl-toggle)
                    
 
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)

(add-to-list 'load-path "~/.emacs.d/plugins")

(require 'yasnippet-bundle)

;(load-file "~/emacs/emacs-rc-cedet.el")
(load-file "~/emacs/cedet/common/cedet.el")
(add-to-list 'load-path "~/emacs/")
;(load-file "~/emacs/my_auto-complete-extension.el")
;; auto complete


;; (semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)     ; Enable prototype help and smart completion 
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)

(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default) 

(global-ede-mode t)                      ; Enable the Project management system
(semantic-load-enable-code-helpers)      
(global-srecode-minor-mode 1)            ; Enable template insertion menu
;(add-to-list 'load-path "~/emacs/color-theme-6.6.0/")
;(require 'color-theme)
;(eval-after-load "color-theme"
;  '(progn
;     (color-theme-initialize)
;     (color-theme-retro-green)))
     
;; for the automatic complete
;(require 'semantic-gcc)
;(defun my-semantic-hook()
;  (imenu-add-to-menubar "TAGS"))
;(add-hook 'semantic-init-hooks 'my-semantic-hook)
;(require 'semanticdb-global)
;(semanticdb-enable-gnu-global-databases 'c++-mode)
;(semanticdb-enable-gnu-global-databases 'c-mode)
;(defun my-cedet-hook ()
;  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
;  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
;  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
;  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle))
;(add-hook 'c-mode-common-hook 'my-cedet-hook)

;(defun my-c-mode-cedet-hook ()
; (local-set-key "." 'semantic-complete-self-insert)
; (local-set-key ">" 'semantic-complete-self-insert))
;(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
;(define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)

; duplicated one line
(global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y")


;(define-key your-mode-map-here "." 'semantic-complete-self-insert)
(ede-cpp-root-project "2011S_Boundary" 
                      :name "2011S_Boundary"
                      :file "~/2011S_Boundary/Makefile"
                      :include-path '("~/2011S_Boundary"))
                      
                      
;(defun maximize-frame () 
;(interactive)
;(set-frame-position (selected-frame) 0 0)
;(set-frame-size (selected-frame) 1000 1000))
;(global-set-key (kbd "<s-return>") 'maximize-frame)                      
;(global-ede-mode t)
;(setf yas/indent-line NIL)
;(load-file "~/.emacs.d/plugins/cedet-1.0/common/cedet.el")
;(global-ede-mode 1)
;(semantic-load-enable-code-helpers)
;(global-srecode-minor-mode 1)       
;(semantic-load-enable-guady-code-helpers)
;(semantic-add-system-include "~/exp/include/boost_1_37" 'c++-mode)
;(require 'semantic-ia)
;(require 'semantic-gcc)
;(define-key your-mode-map-here "." 'semantic-complete-self-insert)
;(define-key c-mode-base-map [(tab)] 'semantic-complete-self-insert)
;(global-set-key "\C-w" 'backward-kill-word)
;(global-set-key "\C-x\C-k" 'kill-region)
;(global-set-key "\C-c\C-K" 'kill-regain)
;(global-set-key "\C-x\C-m" 'execute-extended-command)
;(global-set-key "\C-c\C-m" 'execute-extended-command)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(tool-bar-mode nil))

;(global-set-key [M-left] 'windmove-left)          ; move to left windnow
;(global-set-key [M-right] 'windmove-right)        ; move to right window
;(global-set-key [M-up] 'windmove-up)              ; move to upper window
;(global-set-key [M-down] 'windmove-down) 
