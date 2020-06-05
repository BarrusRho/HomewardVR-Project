using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoatStop : MonoBehaviour
{
    [SerializeField]
    private PlayerMovement _playerMovement;

    [SerializeField]
    private GameObject _waterMoving;

    [SerializeField]
    private GameObject _waterStopped;

    [SerializeField]
    private GameObject _greenHeart;

    [SerializeField]
    private Transform _spawnPoint;

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
            _playerMovement._movementSpeed = 0.0f;

            _waterMoving.SetActive(false);

            _waterStopped.SetActive(true);

            Instantiate(_greenHeart, _spawnPoint);
        }
    }
}
