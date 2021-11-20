PROBLEM_NAME = "Towers of Hanoi"

def can_move(s,From,To):
  try:
   pf=s.d[From] # peg disk goes from
   pt=s.d[To]   # peg disk goes to
   if pf==[]: return False  # no disk to move.
   df=pf[-1]  # get topmost disk at From peg..
   if pt==[]: return True # no disk to worry about at To peg.
   dt=pt[-1]  # get topmost disk at To peg.
   if df<dt: return True # Disk is smaller than one it goes on.
   return False # Disk too big for one it goes on.
  except (Exception) as e:
   print(e)

def move(s,From,To):
  news = s.__copy__() # start with a deep copy.
  d2 = news.d # grab the new state's dictionary.
  pf=d2[From] # peg disk goes from.
  df=pf[-1]  # the disk to move.
  d2[From]=pf[:-1] # remove it from its old peg.
  d2[To]+=[df] # Put disk onto destination peg.
  return news # return new state

def goal_test(s):
  return s.d['peg1']==[] and s.d['peg2']==[] and s.d['peg3']==[]

def goal_message(s):
  return "Solving the Tower Of Hanoi Puzzle"

class Operator:
  def __init__(self, name, precond, state_transf):
    self.name = name
    self.precond = precond
    self.state_transf = state_transf

  def is_applicable(self, s):
    return self.precond(s)

  def apply(self, s):
    return self.state_transf(s)

def h_hamming3(state):
  p3 = state.d['peg4']
  return N_disks - len(p3)

def h_weighted_hamming(state):
  p3 = state.d['peg4']
  sum = 0
  for n in range(1,N_disks+1):
    if not (n in p3): sum += n
  return sum

N_disks = 7

class State():
  def __init__(self, d):
    self.d = d

  def __str__(self):
    d = self.d
    txt = "["
    for i, peg in enumerate(['peg1','peg2','peg3','peg4']):
      txt += str(d[peg])
      if i<2: txt += ","
    return txt+"]"

  def __eq__(self, s2):
    if not (type(self)==type(s2)): return False
    d1 = self.d; d2 = s2.d
    return d1['peg1']==d2['peg1'] and d1['peg2']==d2['peg2'] and d1['peg3']==d2['peg3'] and d1['peg4']==d2['peg4']

  def __hash__(self):
    return (str(self)).__hash__()

  def __copy__(self):
    news = State({})
    for peg in ['peg1', 'peg2', 'peg3','peg4']:
      news.d[peg]=self.d[peg][:]
    return news

INITIAL_STATE = State({'peg1': list(range(N_disks,0,-1)), 'peg2':[], 'peg3':[] , 'peg4':[] })
CREATE_INITIAL_STATE = lambda: INITIAL_STATE

peg_combinations = [('peg'+str(a),'peg'+str(b)) for (a,b) in
                    [(1,2),(1,3),(1,4),(2,1),(2,3),(2,4),(3,1),(3,2),(3,4),(4,1),(4,2),(4,3)]]
OPERATORS = [Operator("Move disk from "+p+" to "+q,
                      lambda s,p1=p,q1=q: can_move(s,p1,q1),
                      lambda s,p1=p,q1=q: move(s,p1,q1) )
             for (p,q) in peg_combinations]

GOAL_TEST = lambda s: goal_test(s)

GOAL_MESSAGE_FUNCTION = lambda s: goal_message(s)

HEURISTICS = {'h_hamming3': h_hamming3, 'h_weighted_hamming':h_weighted_hamming}
