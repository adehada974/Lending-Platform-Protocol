;; Interest Rate Model Contract

(define-data-var base-rate uint u100)  ;; 1% represented as 100
(define-data-var rate-multiplier uint u50)  ;; 0.5% represented as 50

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))

(define-public (set-base-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (var-set base-rate new-rate)
    (ok true)
  )
)

(define-public (set-rate-multiplier (new-multiplier uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (var-set rate-multiplier new-multiplier)
    (ok true)
  )
)

(define-read-only (calculate-interest-rate (utilization-rate uint))
  (ok (+ (var-get base-rate) (* utilization-rate (var-get rate-multiplier))))
)

(define-read-only (get-base-rate)
  (ok (var-get base-rate))
)

(define-read-only (get-rate-multiplier)
  (ok (var-get rate-multiplier))
)

