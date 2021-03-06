class Symbol {
  """
  Symbols are unique identifiers and only created once.

  If there are several occurrances of the same Symbol literal within
  Fancy code, they all refer to the same Symbol object.
  """

  def call: arg {
    """
    This allows Symbols to be used like Blocks
    (e.g. in all methods of Enumerable).
    Example: [1, 2, 3] map: 'squared # => [1, 4, 9]
    """

    arg is_a?: Array . if_true: {
      arg first send: self params: $ arg rest
    } else: {
      arg send: self
    }
  }

}
