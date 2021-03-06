class Class {
  def alias_method: new for: old {
    alias_method(new, old)
  }

  def ruby_alias: method_name {
    alias_method: (":" + (method_name to_s)) for: method_name
  }
}

class String {
  alias_method: ":+" for: "+"
}

class Object {

  ruby_alias: '==
  ruby_alias: '===
  ruby_alias: 'class

  def initialize {
    self initialize()
  }

  def dclone {
    "Returns a deep clone of self using Ruby's Marshal class."
    Marshal load: $ Marshal dump: self
  }

  def ++ other {
    self to_s + (other to_s)
  }

  def to_s {
    self to_s()
  }

  def inspect {
    self inspect()
  }

  def set_slot: slotname value: val {
    instance_variable_set("@" ++ slotname, val)
  }

  def get_slot: slotname {
    instance_variable_get("@" ++ slotname)
  }

  def and: other {
    """
    Boolean conjunction.
    Returns true if self and other are true, otherwise nil.
    """

    self if_do: {
      other if_do: {
        return true
      }
    }
    return false
  }

  def or: other {
    """
    Boolean disjunction.
    Returns true if either self or other is true, otherwise nil.
    """
    self if_do: {
      return true
    } else: {
      other if_do: {
        return true
      }
    }
    return false
  }

  def define_singleton_method: name with: block {
    self metaclass define_method: name with: block
  }

  def undefine_singleton_method: name {
    self metaclass undefine_method: name
  }

  def is_a?: class {
    "Indicates, if an object is an instance of a given Class."
    is_a?(class)
  }

  def kind_of?: class {
    "Indicates, if an object is an instance of a given Class."
    kind_of?(class)
  }

  def send: message {
    self send(message_name: message)
  }

  def send: message params: params {
    ruby: (message_name: message) args: params
  }

  def message_name: symbol {
    symbol = symbol to_s
    symbol includes?: ":" . if_true: {
      symbol
    } else: {
      ":" ++ symbol
    }
  }

  def responds_to?: message {
    self respond_to?(message_name: message)
  }
}
