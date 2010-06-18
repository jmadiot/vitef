from Tkinter import *
import time

class plateau:
	def __init__(self,m,n):
		self.m = m + 1
		self.n = n + 1
		self.coups = 0
		self.mat = []
		for i in xrange(self.m):
			matri = []
			for j in xrange(self.n):
				matri.append(-1)
			self.mat.append(matri)
		self.joueur = 0
		self.cst = 20
		self.tour()
	def test(self,i,j):
		ki = i
		kj = j
		compteur = 0
		while ki >= 0 and self.mat[ki][j] == self.joueur:
			compteur += 1
			ki -= 1
		ki = i + 1
		while ki < self.m and self.mat[ki][j] == self.joueur:
			compteur += 1
			ki += 1
		if compteur >= 5:
			self.fin_partie()
		else:
			compteur = 0
			while kj >= 0 and self.mat[i][kj] == self.joueur:
				compteur += 1
				kj -= 1
			kj = j + 1
			while kj < self.n and self.mat[i][kj] == self.joueur:
				compteur += 1
				kj += 1
			if compteur >= 5:
				self.fin_partie()
			else :
				compteur = 0
				ki = i
				kj = j
				while ki >= 0 and kj >=0 and self.mat[ki][kj] == self.joueur:
					compteur += 1
					ki -= 1
					kj -= 1
				ki = i + 1
				kj = j + 1
				while ki < self.m and kj < self.n and self.mat[ki][kj] == self.joueur:
					compteur += 1
					ki += 1
					kj += 1
				if compteur >= 5:
					self.fin_partie()
				else:
					compteur = 0
					ki = i
					kj = j
					while ki < self.m and kj >= 0 and self.mat[ki][kj] == self.joueur:
						compteur += 1
						ki += 1
						kj -= 1
					ki = i - 1
					kj = j + 1
					while ki >= 0 and kj < self.n and self.mat[ki][kj] == self.joueur:
						compteur += 1
						ki -= 1
						kj += 1
					if compteur >= 5:
						self.fin_partie()
	def fin_partie(self):
		if self.joueur == -1:
			print "Fin de la partie !"
			#egalite
		else:
			if self.joueur == 0:
				print "Le joueur 1 gagne 1 point !"
			else:
				print "Le joueur 2 gagne 1 point !"
			#Le joueur 'joueur' gagne
	def cocher(self,event):
		i = event.y / self.cst
		j = event.x / self.cst
		if self.mat[i][j] != -1:
			self.tour()
		else:
			self.mat[i][j] = self.joueur
			self.test(i,j)
			self.colorier(i,j)
			self.coups += 1
			self.joueur = 1 - self.joueur
			self.tour()
	def colorier(self,i,j):
		if self.joueur == 0:
			coul = "yellow"
		else:
			coul = "red"
		self.can.create_line(self.cst*(j+0.5),self.cst*i+1,self.cst*(j+0.5),self.cst*(i+1),width=self.cst-1,fill=coul)
	def tour(self):
		if self.coups == self.m * self.n:
			fin_partie(-1)
		else:
			if self.coups == 0:
				self.affichage()
			else:
				self.fen1.update_idletasks()
	def affichage(self):
		def drawline(x1,y1,x2,y2):
			self.can.create_line(x1,y1,x2,y2,width=1,fill="black")
		self.fen1 = Tk()
		self.bou = Button(self.fen1,text='Quitter',command=self.fen1.destroy)
		self.bou.pack(side=BOTTOM)
		self.can = Canvas(self.fen1,bg='grey',height=self.cst*(self.m-1),width=self.cst*(self.n-1))
		self.can.pack()
		self.can.bind('<Button-1>',self.cocher)
		for i in xrange(self.m):
			drawline(0,self.cst*i,self.cst*(self.n-1),self.cst*i)
		for j in xrange(self.n):
			drawline(self.cst*j,0,self.cst*j,self.cst*(self.m-1))
		self.fen1.mainloop()
if __name__ == "__main__":
	plateau = plateau(30,50)