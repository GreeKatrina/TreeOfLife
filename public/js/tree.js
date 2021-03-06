

  var labelType, useGradients, nativeTextSupport, animate;

  (function() {
    var ua = navigator.userAgent,
        iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
        typeOfCanvas = typeof HTMLCanvasElement,
        nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
        textSupport = nativeCanvasSupport
          && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
    //I'm setting this based on the fact that ExCanvas provides text support for IE
    //and that as of today iPhone/iPad current text support is lame
    labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
    nativeTextSupport = labelType == 'Native';
    useGradients = nativeCanvasSupport;
    animate = !(iStuff || !nativeCanvasSupport);
  })();

  // Where it says what is loading
  var Log = {
    elem: false,
    write: function(text){
      if (!this.elem)
        this.elem = document.getElementById('log');
      this.elem.innerHTML = text;
      this.elem.style.left = (700 - this.elem.offsetWidth / 2) + 'px';
    }
  };


  function init(){
      //init data
      var json = {
          "name": "Tree of Life",
          "id": 1,
          "parent_id": 0,
          "phylesis": 2,
          "extinct": false,
          "leaf": true,
          "data": {},
          "children": []
      };
      //end
      //init Spacetree
      //Create a new ST instance
      var st = new $jit.ST({
          //id of viz container element
          injectInto: 'infovis',
          //set duration for the animation
          duration: 400,
          //set animation transition type
          transition: $jit.Trans.Quart.easeInOut,
          //set distance between node and its children
          levelDistance: 50,
          levelsToShow: 1,
          //enable panning
          Navigation: {
            enable:true,
            panning:true
          },
          //set node and edge styles
          //set overridable=true for styling individual
          //nodes or edges
          Node: {
              height: 20,
              width: 150,
              type: 'rectangle',
              color: '#317FD9',
              overridable: true
          },
          setColor: function(node){
              if (node.extinct){
                  node.data.$color =  "#204ABA";
              }else{
                  node.data.$color = '#317fd9';
              }
          },
          // set css for lines
          Edge: {
              type: 'bezier',
              lineWidth: 2,
              color: '#3E3E40',
              overridable: true
          },

          onBeforeCompute: function(node){
              Log.write("loading " + node.name);
          },

          onAfterCompute: function(){
              Log.write("done");
          },
          //This method is called on DOM label creation.
          //Use this method to add event handlers and styles to
          //your node.
          onCreateLabel: function(label, node){
              label.id = node.id;
              if (node.name){
                label.innerHTML = node.name;
              }
              var style = label.style;
              if (node.name !== null) {
                style.width = 147 + 'px';
                style.height = 17 + 'px';
                style.cursor = 'pointer';
                // font color of nodes
                style.color = '#F2F1EF';
                style.fontSize = '0.8em';
                style.textAlign= 'center';
                style.paddingTop = '3px';
              }
              label.onclick = function() {
                  st.onClick(node.id, {
                      onComplete: function() {
                          $.ajax({
                            type: 'GET',
                            url: '/node-attributes',
                            data: { id: node.id },
                            success: function(response) {
                              console.log(response);
                              st.addSubtree(response.species, 'replot');
                              $('.wiki_text').empty();
                              if (response.wiki_sidebar){
                                $(".wiki_text").append("<div class='wiki_image'><img src='" +  response.wiki_sidebar + "'></div>");
                              }
                              if (response.wiki.paragraphs){
                                $(".wiki_text").append("<div class='wiki_text'><h4>" +  response.wiki.title + "</h4>" +  response.wiki.paragraphs + "</div>");
                              } else {
                                $(".wiki_text").append("<div class='wiki_text'><h4>" +  response.wiki.title + "</div>");
                              }
                            }
                          });
                      }
                  });
              }
          },

          //This method is called right before plotting
          //a node. It's useful for changing an individual node
          //style properties before plotting it.
          //The data properties prefixed with a dollar
          //sign will override the global node style properties.
          onBeforePlotNode: function(node){
              //add some color to the nodes in the path between the
              //root node and the selected node.
              if (node.selected) {
                  // set color of nodes along the selected path
                  if(node.extinct){
                      node.data.$color = "#490C60";
                  }else{
                      node.data.$color = "#8E44AD";
                  }
              } else {
                  delete node.data.$color;
                  //if the node belongs to the last plotted level
                  if(!node.anySubnode("exist")) {
                      if (node.extinct){
                          node.data.$color = "#204ABA";
                      }else{
                          node.data.$color = '#317fd9';
                      }
                  }
              }
              // name-less nodes will appear as common ancestors
              if (!node.name || node.name === 'Common Ancestor') {
                  node.name = 'Common Ancestor';
              }
          },

          //This method is called right before plotting
          //an edge. It's useful for changing an individual edge
          //style properties before plotting it.
          //Edge data proprties prefixed with a dollar sign will
          //override the Edge global style properties.
          onBeforePlotLine: function(adj){
              if (adj.nodeFrom.selected && adj.nodeTo.selected) {
                  // Change color of lines in selected path
                  adj.data.$color = "#F2F1EF";
                  adj.data.$lineWidth = 3;
              }
              else {
                  delete adj.data.$color;
                  delete adj.data.$lineWidth;
              }
          }
      });
      //load json data
      st.loadJSON(json);
      //compute node positions and layout
      st.compute();
      //optional: make a translation of the tree
      st.geom.translate(new $jit.Complex(-200, 0), "current");
      //emulate a click on the root node.
      st.onClick(st.root);
      //end

  }

