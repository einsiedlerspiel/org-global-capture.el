;;; org-global-capture.el --- description

;;; Commentary:
;; Put together from these sources:
;; http://www.windley.com/archives/2010/12/capture_mode_and_emacs.shtml
;; https://github.com/pashinin/emacsd/blob/master/elisp/init-org-capture.el

;; activated by a keybinding to
;; emacsclient -c -F '(quote (name . "capture"))' -e '(activate-capture-frame)'

;;; Code:

(defadvice org-switch-to-buffer-other-window
    (after supress-window-splitting activate)
  "Delete the extra window if we're in a capture frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-other-windows)))

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (when (and (equal "capture" (frame-parameter nil 'name))
             (not (eq this-command 'org-capture-refile)))
    (delete-frame)))

(defadvice org-capture-refile
    (after delete-capture-frame activate)
  "Advise org-refile to close the frame"
  (when (equal "capture" (frame-parameter nil 'name))
    (delete-frame)))

(defun activate-capture-frame ()
  "run org-capture in capture frame"
  (select-frame-by-name "capture")
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (org-capture))

;; Only works if there's already an other frame:
;; (defun make-capture-frame ()
;;   "Create a new frame and run org-capture."
;;   (interactive)
;;   (make-frame '((name . "capture")
;;                 (width . 90)
;;                 (height . 20)
;;                 (minibuffer . t)
;;                 (window-system . x)
;;                 ))
;;   (activate-capture-frame))

(provide 'org-global-capture)

;;; org-global-capture.el ends here
