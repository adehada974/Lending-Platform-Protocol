;; Lending Pool Contract

(define-map deposits
  { user: principal }
  { amount: uint }
)

(define-map borrows
  { user: principal }
  { amount: uint, collateral: uint }
)

(define-data-var total-deposits uint u0)
(define-data-var total-borrows uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_INSUFFICIENT_FUNDS (err u402))
(define-constant ERR_INSUFFICIENT_COLLATERAL (err u403))

(define-public (deposit (amount uint))
  (let (
    (current-deposit (default-to { amount: u0 } (map-get? deposits { user: tx-sender })))
  )
    (map-set deposits
      { user: tx-sender }
      { amount: (+ (get amount current-deposit) amount) }
    )
    (var-set total-deposits (+ (var-get total-deposits) amount))
    (ok true)
  )
)

(define-public (withdraw (amount uint))
  (let (
    (current-deposit (default-to { amount: u0 } (map-get? deposits { user: tx-sender })))
  )
    (asserts! (<= amount (get amount current-deposit)) ERR_INSUFFICIENT_FUNDS)
    (map-set deposits
      { user: tx-sender }
      { amount: (- (get amount current-deposit) amount) }
    )
    (var-set total-deposits (- (var-get total-deposits) amount))
    (ok true)
  )
)

(define-public (borrow (amount uint) (collateral uint))
  (let (
    (current-borrow (default-to { amount: u0, collateral: u0 } (map-get? borrows { user: tx-sender })))
  )
    (asserts! (>= (* collateral u2) amount) ERR_INSUFFICIENT_COLLATERAL)
    (map-set borrows
      { user: tx-sender }
      { amount: (+ (get amount current-borrow) amount), collateral: (+ (get collateral current-borrow) collateral) }
    )
    (var-set total-borrows (+ (var-get total-borrows) amount))
    (ok true)
  )
)

(define-public (repay (amount uint))
  (let (
    (current-borrow (default-to { amount: u0, collateral: u0 } (map-get? borrows { user: tx-sender })))
  )
    (asserts! (<= amount (get amount current-borrow)) ERR_INSUFFICIENT_FUNDS)
    (map-set borrows
      { user: tx-sender }
      { amount: (- (get amount current-borrow) amount), collateral: (get collateral current-borrow) }
    )
    (var-set total-borrows (- (var-get total-borrows) amount))
    (ok true)
  )
)

(define-read-only (get-user-deposit (user principal))
  (map-get? deposits { user: user })
)

(define-read-only (get-user-borrow (user principal))
  (map-get? borrows { user: user })
)

(define-read-only (get-total-deposits)
  (ok (var-get total-deposits))
)

(define-read-only (get-total-borrows)
  (ok (var-get total-borrows))
)
