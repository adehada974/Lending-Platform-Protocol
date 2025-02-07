;; Credit Scoring Contract

(define-map credit-scores
  { user: principal }
  { score: uint }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))

(define-public (update-credit-score (user principal) (new-score uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set credit-scores { user: user } { score: new-score })
    (ok true)
  )
)

(define-read-only (get-credit-score (user principal))
  (default-to { score: u0 } (map-get? credit-scores { user: user }))
)

(define-read-only (is-credit-worthy (user principal) (minimum-score uint))
  (let ((user-score (get score (get-credit-score user))))
    (ok (>= user-score minimum-score))
  )
)

