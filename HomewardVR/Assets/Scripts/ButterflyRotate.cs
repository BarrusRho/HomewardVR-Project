using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButterflyRotate : MonoBehaviour
{
    [SerializeField]
    private float _speed = 50f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(0, _speed * Time.deltaTime, 0);
    }
}
