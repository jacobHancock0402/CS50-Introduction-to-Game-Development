using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Hud : MonoBehaviour {

	// Use this for initialization
    public Text Maze;
	void Start () {
        Maze = GameObject.Find("Canvas/Text").GetComponent<Text>();
		
	}
	
	// Update is called once per frame
	void Update () {
        Maze.text = "Maze " + GrabPickups.MazeCount;
		
	}
}