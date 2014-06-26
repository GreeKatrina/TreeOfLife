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
          "name": "Life on Earth",
          "species_id": 1,
          "parent_id": 0,
          "phylesis": 0,
          "extinct": true,
          "leaf": true,
          "children": [
              {
                  "name": "Eubacteria",
                  "species_id": 2,
                  "parent_id": 1,
                  "phylesis": 0,
                  "extinct": true,
                  "leaf": true
              },
              {
                  "name": "Eukaryotes",
                  "species_id": 3,
                  "parent_id": 1,
                  "phylesis": 0,
                  "extinct": true,
                  "leaf": true
              },
              {
                  "name": "Archaea",
                  "species_id": 4,
                  "parent_id": 1,
                  "phylesis": 1,
                  "extinct": true,
                  "leaf": true
              },
              {
                  "name": "Viruses",
                  "species_id": 5,
                  "parent_id": 1,
                  "phylesis": 1,
                  "extinct": true,
                  "leaf": true
              }
          ]
      };
    //end
    //init Spacetree
    //Create a new ST instance
    var st = new $jit.ST({
        //id of viz container element
        injectInto: 'infovis',
        //set duration for the animation
        duration: 800,
        //set animation transition type
        transition: $jit.Trans.Quart.easeInOut,
        //set distance between node and its children
        levelDistance: 50,
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
            color: '#fff',
            overridable: true
        },
        setColor: function(node){
            if (node.extinct === true){
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
            label.innerHTML = node.name;
            label.onclick = function() {
                // TODO: PUT TREE SUDO CODE RIGHT HERE!
              st.onClick(node.id);
                st.setRoot(node.id, 'animate');
            };
            //set label styles
            if (node.name !== null) {
                var style = label.style;
                style.width = 120 + 'px';
                style.height = 17 + 'px';
                style.cursor = 'pointer';
                // font color of nodes
                style.color = '#F2F1EF';
                style.fontSize = '0.8em';
                style.textAlign= 'center';
                style.paddingTop = '3px';
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
                if(node.extinct === true){
                    node.data.$color = "#490C60";
                }else{
                    node.data.$color = "#8E44AD";
                }
            } else {
                delete node.data.$color;
                //if the node belongs to the last plotted level
                if(!node.anySubnode("exist")) {
                    if (node.extinct === true){
                        node.data.$color = "#204ABA";
                    }else{
                        node.data.$color = '#317fd9';
                    }
                }
            }
            // hacky way to make name-less nodes appear as lines
            if (node.name === null) {
                if (node.selected) {
                    node.data.$height = 3;
                    node.data.$color = "#F2F1EF";
                } else {
                    node.data.$height = 2;
                    node.data.$color  = "#3E3E40";
                }
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
    //Add event handlers to switch spacetree orientation.
    var left = $jit.id('r-left'),
        right = $jit.id('r-right');


    function changeHandler() {
        if(this.checked) {
            right.disabled = left.disabled = true;
            st.switchPosition(this.value, "animate", {
                onComplete: function(){
                    right.disabled = left.disabled = false;
                }
            });
        }
    };

    left.onchange = right.onchange = changeHandler;
    //end

}
