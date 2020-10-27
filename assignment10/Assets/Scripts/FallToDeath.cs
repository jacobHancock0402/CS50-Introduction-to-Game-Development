using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class FallToDeath : MonoBehaviour {

	// Use this for initialization
    public GameObject a;
    public static int v;
    public GameObject Whisper;
	void Start () {
		
	}
	// Update is called once per frame
	void Update () {
		if (gameObject.transform.position.y < 0.8) {
            v = 0;
            Destroy(GameObject.FindWithTag("WhisperSource"));
            GrabPickups.MazeCount = 0;
            SceneManager.LoadScene("GameOver");
            v = 0;
        }
	}
}