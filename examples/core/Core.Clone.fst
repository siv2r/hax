module Core.Clone

class t_Clone self = {
  f_clone: self -> self
}

instance clone_all (t: Type): t_Clone t = {
  f_clone = (fun x -> x);
}

