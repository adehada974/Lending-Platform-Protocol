;; Collateral Management Contract

(define-map collateral-factors
  { asset: principal }
  { factor: uint }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_INVALID_COLLATERAL (err u402))

(define-public (set-collateral-factor (asset principal) (factor uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (<= factor u10000) ERR_INVALID_COLLATERAL)  ;; Factor must be between 0 and 100%
    (map-set collateral-factors { asset: asset } { factor: factor })
    (ok true)
  )
)

(define-public (liquidate (borrower principal) (liquidator principal) (asset principal) (repay-amount uint))
  ;; Simplified liquidation logic
  ;; In a real implementation, this would interact with other contracts and handle token transfers
  (ok true)
)

(define-read-only (get-collateral-factor (asset principal))
  (map-get? collateral-factors { asset: asset })
)

(define-read-only (is-liquidatable (borrower principal) (borrow-balance uint) (collateral-value uint))
  (ok (< (* collateral-value u10000) (* borrow-balance u11000)))  ;; Liquidate if collateral value is less than 110% of borrow balance
)

