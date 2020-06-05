using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoatSlow : MonoBehaviour
{
    [SerializeField]
    private PlayerMovement _playerMovement;

    // Start is called before the first frame update
    void Start()
    {
        _playerMovement = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerMovement>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "EventTrigger")
        {
            _playerMovement._movementSpeed = 0.8f;
        }
    }
}
