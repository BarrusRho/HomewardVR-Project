using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookatPlayer : MonoBehaviour
{
    public Transform target;

	// Use this for initialization
	void Start ()
    {
        target = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Transform>();
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (target != null)
        {
            transform.LookAt(target);
        }
    }
}
