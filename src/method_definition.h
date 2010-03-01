#ifndef _METHOD_DEFINITION_H_
#define _METHOD_DEFINITION_H_

class MethodDefExpr : public Object
{
 public:
  MethodDefExpr(list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method);
  MethodDefExpr(Identifier_p name, Method_p method);

  virtual Object_p equal(const Object_p other) const;
  virtual string to_s() const;
  virtual Object_p eval(Scope *scope);
 
private:
  list< pair<Identifier_p, Identifier_p> > method_args;
  Method_p method;
};

#endif /* _METHOD_DEFINITION_H_ */