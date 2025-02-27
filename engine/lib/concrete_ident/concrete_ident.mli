type t [@@deriving show, yojson, compare, sexp, eq, hash]
type name = Concrete_ident_generated.name

module ImplInfoStore : sig
  val init : (Types.def_id * Types.impl_infos) list -> unit
end

module Kind : sig
  type t =
    | Type
    | Value
    | Lifetime
    | Constructor of { is_struct : bool }
    | Field
    | Macro
    | Trait
    | Impl
    | AssociatedItem of t
  [@@deriving show, yojson, compare, sexp, eq, hash]
end

val of_def_id : Kind.t -> Types.def_id -> t
val of_name : Kind.t -> name -> t
val eq_name : name -> t -> bool
val to_debug_string : t -> string

module Create : sig
  val fresh_module : from:t list -> t
  val move_under : new_parent:t -> t -> t
end

type view = { crate : string; path : string list; definition : string }

val map_path_strings : f:(string -> string) -> t -> t
val matches_namespace : Types.namespace -> t -> bool

include module type of struct
  include Concrete_ident_sig.Make (struct
    type t_ = t
    type view_ = view
  end)
end

module MakeViewAPI (NP : NAME_POLICY) : VIEW_API
module DefaultNamePolicy : NAME_POLICY
module DefaultViewAPI : VIEW_API

type comparator_witness

val comparator : (t, comparator_witness) Base.Comparator.comparator
