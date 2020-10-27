using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Des : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (FallToDeath.v == 0) {

            Destroy(gameObject);
        }
	}
}