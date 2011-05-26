// ==UserScript==
// @name           Kraland - Forum - Ignore List
// @namespace      none
// @include        http://www.kraland.org/main.php*
// ==/UserScript==
Message = {
	auteur : function(pseudo){
		return posts[i].getElementsByTagName('p')[0].innerHTML.indexOf('p1=' + pseudo) != -1;
	},
	filtrage: function(){
		tab_pseudo = this.liste_pseudos.split(',');
		if(posts = document.getElementsByClassName("post_container")){
			for ( i = 0 ; i < posts.length ; i++) {
				for(j=0;j<tab_pseudo.length;j++){
					if (this.auteur(tab_pseudo[j])){
						this.disparait(posts[i]);
					} 
				}
			}
		}
	},
	disparait: function(item){
		item.style.display='none';
	}
}
Message.liste_pseudos = '30817';
Message.filtrage();
