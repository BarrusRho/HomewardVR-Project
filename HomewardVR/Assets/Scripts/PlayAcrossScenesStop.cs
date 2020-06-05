using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayAcrossScenesStop : MonoBehaviour
{

	// Use this for initialization
	void Start ()
    {
        PlayAcrossScenes.Instance.gameObject.GetComponent<AudioSource>().Stop();
	}
	
	// Update is called once per frame
	void Update ()
    {
		
	}
}
