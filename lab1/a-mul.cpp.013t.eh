
;; Function main (main, funcdef_no=1776, decl_uid=46757, cgraph_uid=510, symbol_order=540)

int main ()
{
  struct basic_ostream & D.51665;
  int f;
  int n;
  int i;
  int D.51663;

  std::basic_istream<char>::operator>> (&cin, &n);
  i = 2;
  f = 1;
  goto <D.46817>;
  <D.46818>:
  f = f * i;
  i = i + 1;
  <D.46817>:
  n.0_1 = n;
  if (i <= n.0_1) goto <D.46818>; else goto <D.46816>;
  <D.46816>:
  D.51665 = std::basic_ostream<char>::operator<< (&cout, f);
  _2 = D.51665;
  std::basic_ostream<char>::operator<< (_2, endl);
  D.51663 = 0;
  goto <D.51667>;
  <D.51667>:
  n = {CLOBBER};
  goto <D.51664>;
  D.51663 = 0;
  goto <D.51664>;
  <D.51664>:
  return D.51663;
  <D.51666>:
  n = {CLOBBER};
  resx 1
}



;; Function std::endl<char, std::char_traits<char> > (_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_, funcdef_no=2037, decl_uid=44183, cgraph_uid=771, symbol_order=804)

struct basic_ostream & std::endl<char, std::char_traits<char> > (struct basic_ostream & __os)
{
  struct basic_ostream & D.51673;
  struct basic_ostream & D.51672;
  char D.51671;
  struct basic_ostream & D.51669;

  _1 = __os->_vptr.basic_ostream;
  _2 = _1 + 18446744073709551592;
  _3 = MEM[(long int *)_2];
  _4 = (sizetype) _3;
  _5 = __os + _4;
  D.51671 = std::basic_ios<char>::widen (_5, 10);
  _6 = D.51671;
  D.51672 = std::basic_ostream<char>::put (__os, _6);
  _7 = D.51672;
  D.51673 = std::flush<char, std::char_traits<char> > (_7);
  D.51669 = D.51673;
  goto <D.51670>;
  <D.51670>:
  return D.51669;
}



;; Function std::basic_ios<char>::widen (_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc, funcdef_no=2116, decl_uid=43229, cgraph_uid=850, symbol_order=883)

char_type std::basic_ios<char>::widen (const struct basic_ios * const this, char __c)
{
  char_type D.51677;
  const struct ctype & D.51676;
  char_type D.51674;

  _1 = this->_M_ctype;
  D.51676 = std::__check_facet<std::ctype<char> > (_1);
  _2 = D.51676;
  D.51677 = std::ctype<char>::widen (_2, __c);
  D.51674 = D.51677;
  goto <D.51675>;
  <D.51675>:
  return D.51674;
}



;; Function std::__check_facet<std::ctype<char> > (_ZSt13__check_facetISt5ctypeIcEERKT_PS3_, funcdef_no=2152, decl_uid=49954, cgraph_uid=886, symbol_order=919)

const struct ctype & std::__check_facet<std::ctype<char> > (const struct ctype * __f)
{
  const struct ctype & D.51680;

  if (__f == 0B) goto <D.51678>; else goto <D.51679>;
  <D.51678>:
  std::__throw_bad_cast ();
  <D.51679>:
  D.51680 = __f;
  goto <D.51681>;
  <D.51681>:
  return D.51680;
}



;; Function std::ctype<char>::widen (_ZNKSt5ctypeIcE5widenEc, funcdef_no=1524, decl_uid=39667, cgraph_uid=495, symbol_order=524)

char_type std::ctype<char>::widen (const struct ctype * const this, char __c)
{
  char_type D.51686;
  char_type D.51684;

  _1 = this->_M_widen_ok;
  if (_1 != 0) goto <D.51682>; else goto <D.51683>;
  <D.51682>:
  _2 = (int) __c;
  D.51684 = this->_M_widen[_2];
  // predicted unlikely by early return (on trees) predictor.
  goto <D.51685>;
  <D.51683>:
  std::ctype<char>::_M_widen_init (this);
  _3 = this->D.39781._vptr.facet;
  _4 = _3 + 48;
  _5 = *_4;
  D.51686 = OBJ_TYPE_REF(_5;(const struct ctype)this->6) (this, __c);
  D.51684 = D.51686;
  goto <D.51685>;
  <D.51685>:
  return D.51684;
}



;; Function std::ctype<char>::do_widen (_ZNKSt5ctypeIcE8do_widenEc, funcdef_no=1529, decl_uid=39715, cgraph_uid=500, symbol_order=529)

char_type std::ctype<char>::do_widen (const struct ctype * const this, char __c)
{
  char_type D.51687;

  D.51687 = __c;
  goto <D.51688>;
  <D.51688>:
  return D.51687;
}



;; Function std::flush<char, std::char_traits<char> > (_ZSt5flushIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_, funcdef_no=2117, decl_uid=44191, cgraph_uid=851, symbol_order=884)

struct basic_ostream & std::flush<char, std::char_traits<char> > (struct basic_ostream & __os)
{
  struct basic_ostream & D.51691;
  struct basic_ostream & D.51689;

  D.51691 = std::basic_ostream<char>::flush (__os);
  D.51689 = D.51691;
  goto <D.51690>;
  <D.51690>:
  return D.51689;
}



;; Function std::basic_ostream<char>::operator<< (_ZNSolsEPFRSoS_E, funcdef_no=2038, decl_uid=43971, cgraph_uid=772, symbol_order=805)

struct __ostream_type & std::basic_ostream<char>::operator<< (struct basic_ostream * const this, struct __ostream_type & (*<T6878>) (struct __ostream_type &) __pf)
{
  struct __ostream_type & D.51694;
  struct __ostream_type & D.51692;

  __pf.1_1 = __pf;
  D.51694 = __pf.1_1 (this);
  D.51692 = D.51694;
  goto <D.51693>;
  <D.51693>:
  return D.51692;
}



;; Function _GLOBAL__sub_I_main (_GLOBAL__sub_I_main, funcdef_no=2277, decl_uid=51661, cgraph_uid=1011, symbol_order=1186)

void _GLOBAL__sub_I_main ()
{
  __static_initialization_and_destruction_0 (1, 65535);
  return;
}



;; Function __static_initialization_and_destruction_0 (_Z41__static_initialization_and_destruction_0ii, funcdef_no=2276, decl_uid=51655, cgraph_uid=1010, symbol_order=1067)

void __static_initialization_and_destruction_0 (int __initialize_p, int __priority)
{
  if (__initialize_p == 1) goto <D.51695>; else goto <D.51696>;
  <D.51695>:
  if (__priority == 65535) goto <D.51697>; else goto <D.51698>;
  <D.51697>:
  std::ios_base::Init::Init (&__ioinit);
  __cxxabiv1::__cxa_atexit (__dt_comp , &__ioinit, &__dso_handle);
  goto <D.51699>;
  <D.51698>:
  <D.51699>:
  goto <D.51700>;
  <D.51696>:
  <D.51700>:
  return;
}


